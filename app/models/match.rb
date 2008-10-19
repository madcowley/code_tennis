class Match < ActiveRecord::Base
  belongs_to :admin, :class_name => "User"
  has_many :players
  has_many :users, :through => :players
  has_many :volleys

  validates_presence_of :admin_id
  validates_presence_of :name
  validates_presence_of :github_user
  validates_presence_of :github_project

  def github_url
    "http://github.com/#{github_user}/#{github_project}"
  end

  def active_volley
    volleys.incomplete.first
  end
  
  def current_player
    self.active_volley.player
  end

  def next_player
    if current_player.nil?
      next_player = players.find(:first)
    else
      next_player = players.find(:first, :conditions => "id != #{current_player.id}")
    end
  end

  def push(payload)
    commits = ActiveSupport::JSON.decode(payload)["commits"]
    commits.each do |commit|
      user = self.users.find_by_email(commit["author"]["email"])
      self.active_volley.commits.create({
        :guid    => commit["id"],
        :url     => commit["url"],
        :message => commit["message"],
        :player  => self.players.find_by_user_id(user.id)
      })
      new_volley if commit["message"] =~ /volley/
    end
  end

  def complete?
    !!(self.completed_at)
  end

  def complete!
    self.update_attribute :completed_at, Time.now
  end

  def volley!
    player = self.next_player
    self.active_volley.update_attribute :completed_at, Time.now
    self.volleys.create(:player => player) unless complete?
  end

  def notify_players
    players.each do |player|
      Twitter.update("@#{player.twitter_name} New Volley: <a href=\"http://#{ENV['HOSTNAME']}/matches/#{self.id}\">#{self.name }</a> ") if player.twitter_name
    end
  end

  def possible_admins
    users = players.map(&:user)
    (users << admin).uniq
  end
  
  def active?
    self.active
  end
  
end
