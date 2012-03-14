require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AssignmentHistoriesController do
  setup :activate_authlogic
  
  describe "not logged in" do
    it "should require login" do
      get :index, :user_id => 12
      response.should redirect_to("/login")
    end
  end

  describe "user" do
    render_views

    it "should render history" do
      @assignemt_history = Factory.create(:assignment_history, :role => "editor")
      UserSession.create(@assignemt_history.user)

      get :index, :user_id => @assignemt_history.user_id
      response.should be_success
      response.should render_template("index")
      response.body.should =~ /#{@assignemt_history.task.name}/
    end
  end

end
