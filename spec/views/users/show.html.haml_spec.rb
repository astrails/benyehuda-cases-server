require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/show.html.haml" do
  setup :activate_authlogic

  [:user, :active_user, :editor, :admin, :volunteer].each do |u|
    describe "for #{u}" do
      before(:each) do
        @user = assigns[:user] = Factory.create(u)
        view.stub!(:current_user).and_return(@user)
        view.stub!(:when_admin).and_return(false)
        view.stub!(:when_current_user).and_return(true)
      end

      describe "users/show" do
        it "should render public profile" do
          view.stub!(:public_profile?).and_return(true)
          view.view_context.stub!(:public_profile?).and_return(true)
          render :template => "/users/show"
        end

        it "should render not public profile" do
          view.stub!(:public_profile?).and_return(false)
          view.view_context.stub!(:public_profile?).and_return(false)
          render :template => "/users/show"
        end
      end
    end
  end
  it "should_link_to users_path"
  it "should have more tests"
end
