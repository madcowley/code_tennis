require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/matches/new.html.erb" do
  include MatchesHelper
  
  before(:each) do
    assigns[:match] = stub_model(Match,
      :new_record? => true,
      :name => "value for name",
      :description => "value for description",
      :github_user => "value for github_user",
      :github_project => "value for github_project"
    )
  end

  it "should render new form" do
    render "/matches/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", matches_path) do
      with_tag("input#match_name[name=?]", "match[name]")
      with_tag("textarea#match_description[name=?]", "match[description]")
      with_tag("input#match_github_user[name=?]", "match[github_user]")
      with_tag("input#match_github_project[name=?]", "match[github_project]")
    end
  end
end


