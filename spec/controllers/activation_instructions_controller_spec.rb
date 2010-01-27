require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivationInstructionsController do

  setup :activate_authlogic

  describe "(guest)" do
    it "should not allow access" do
      post :create, :user_id => 12
      response.should redirect_to("/login")
    end
  end

  describe "user" do
    it "should not allow access" do
      UserSession.create(Factory.create(:active_user))
      post :create, :user_id => 12
      response.should redirect_to("/")
    end
  end

  describe "admin" do
    before(:each) do
      UserSession.create(Factory.create(:admin))
    end

    it "should send activation email" do
      @user = Factory.create(:user)
      @user.reload.activation_email_sent_at.should be_blank
      post :create, :user_id => @user.id, :page => 12
      response.should redirect_to("/users?page=12")
      ActionMailer::Base.deliveries.last.to_s.should =~ /To activate your/
      @user.reload.activation_email_sent_at.should_not be_blank
    end    
  end
end
