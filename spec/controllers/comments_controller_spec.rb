require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentsController do

  setup :activate_authlogic
  render_views

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

  describe "destroy" do
    describe "any user" do
      it "should not allow perform this operation" do
        @user = Factory.create(:active_user)
        UserSession.create(@user)
        delete :destroy, :id => 123, :task_id => 123
        response.should be_redirect
      end
    end
    describe "admin" do
      it "should allow deleteing a comment" do
        @user = Factory.create(:admin)
        UserSession.create(@user)

        task = Factory.create(:task)
        Task.stub!(:find).and_return(task)
        comment = mock_model(Comment)
        task.comments.stub!(:find).and_return(comment)

        comment.stub!(:destroy).and_return(true)
        xhr :delete, :destroy, :id => 123, :task_id => 123
        response.should be_success
        response.should render_template("destroy.rjs")
      end
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
      response.should render_template("comments/_new.html.haml")
    end
  end

end
