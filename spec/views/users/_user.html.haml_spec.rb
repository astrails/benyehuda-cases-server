require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/_user.html.haml" do
  setup :activate_authlogic
  before(:each) do
    @factory = :user
    @user = assigns[:user] = Factory.create(:user)
    template.stub!(:user).and_return(@user)
  end

  it "should_link_to_show"
  it "should_link_to_delete"
end
