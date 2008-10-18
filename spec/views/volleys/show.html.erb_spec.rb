require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/volleys/show.html.erb" do
  include VolleysHelper
  
  before(:each) do
    assigns[:volley] = @volley = stub_model(Volley,
      :player_id => 1,
      :match_id  => 1
    )
  end

  it "should render attributes in <p>" do
    render "/volleys/show.html.erb"
  end
end

