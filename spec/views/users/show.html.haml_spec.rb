require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/show.html.haml" do
  setup :activate_authlogic

  [:user, :active_user, :editor, :admin, :volunteer].each do |u|
    describe "for #{u}" do
      before(:each) do
        @user = assigns[:user] = Factory.create(u)
        @controller.stub!(:current_user).and_return(@user)
      end

      it "should render public profile" do
        @controller.stub!(:public_profile?).and_return(true)
        @controller.view_context.stub!(:public_profile?).and_return(true)
        render "/users/show"
      end

      it "should render not public profile" do
        @controller.stub!(:public_profile?).and_return(false)
        @controller.view_context.stub!(:public_profile?).and_return(false)
        render "/users/show"
      end
    end
  end
  it "should_link_to users_path"
  it "should have more tests"
end
