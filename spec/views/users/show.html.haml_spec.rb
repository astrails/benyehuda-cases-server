require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/show.html.haml" do
  setup :activate_authlogic
  before(:each) do
    @user = assigns[:user] = Factory.build(:user)
  end

  it "should render" do
    render "/users/show"
  end

  it "should_link_to users_path"
  it "should have more tests"
end
