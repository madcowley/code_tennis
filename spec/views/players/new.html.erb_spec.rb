require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/players/new.html.erb" do
  include PlayersHelper
  
  before(:each) do
    assigns[:player] = stub_model(Player,
      :new_record? => true,
      :user_id  => 1,
      :match_id => 1
    )
  end

  it "should render new form" do
    render "/players/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", players_path) do
    end
  end
end


