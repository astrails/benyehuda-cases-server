require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/index.html.haml" do
  setup :activate_authlogic
  before(:each) do
    @users = assigns[:users] = (Array.new(2) {Factory.create(:user)}).paginate
  end

  it "should render" do
    render '/users/index'
  end

  it "should have more tests"
end
