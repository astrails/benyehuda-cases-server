require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WelcomeController do
  setup :activate_authlogic
  integrate_views


  describe "not logged in user" do
    it "should render index" do
      get :index
      response.should render_template("index")
    end
  end

  describe "logged in user" do
    it "should redirect to dashboard" do
      @user = Factory.create(:active_user)
      UserSession.create(@user)
      get :index
      response.should redirect_to("/dashboard")
    end
  end
end
