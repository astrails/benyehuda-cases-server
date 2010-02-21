require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TaskRequestsController do

  setup :activate_authlogic

  describe "not logged in users" do
    describe_action(:create) do
      before(:each) do
        @params = {:id => 1}
      end
      it_should_require_login
    end
  end

  describe "request" do
    it "should reset task_requested_at" do
      @user = Factory.create(:volunteer)
      UserSession.create(@user)
      @user.task_requested_at.should be_nil
      post :create
      response.should be_success #rjs only
      @user.reload.task_requested_at.should_not be_nil
    end
  end

end
