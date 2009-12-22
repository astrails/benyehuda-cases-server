require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentsController do

  setup :activate_authlogic
  integrate_views

  before(:each) do
    @task = Factory.create(:task)
    @task.stub!(:to_param).and_return("1")
    Task.stub!(:find).and_return(@task)
  end

  describe "any user" do
    before(:each) do
      @user = Factory.create(:active_user)
      UserSession.create(@user)
    end

    describe_action(:create) do
      before(:each) do
        @params = {:task_id => "1"}
      end
      it_should_redirect_to "/tasks/1"
    end
  end

  describe "create" do
    before(:each) do
      @user = Factory.create(:active_user)
      UserSession.create(@user)
      @controller.stub!(:require_task_participant).and_return(true)
    end

    it "should render back comment" do
      xhr :post, :create, :task_id => 1, :comment => {:message => "lalala"}
      response.should be_success
      response.body.should =~ /lalala/
    end

    it "should render back an error" do
      xhr :post, :create, :task_id => 1, :comment => {}
      response.should be_success
      response.should render_template("new")
    end
  end

end
