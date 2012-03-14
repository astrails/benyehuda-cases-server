require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AssignmentsController do

  setup :activate_authlogic
  render_views

  describe "no one" do
    [:edit, :update].each do |a|
      describe_action(a) do
        before(:each) do
          @params = {:id => 1, :task_id => 12}
        end
        it_should_require_login
      end      
    end
  end

  describe "editor/admin" do
    before(:each) do
      @user = Factory.create(:editor)
      UserSession.create(@user)
      @task = Factory.create(:task)
      @task.stub!(:children).and_return([])
      Task.stub!(:find).and_return(@task)
    end

    it "should assign a task to self as editor" do
      @task.should_receive(:assign_by_user_ids!).with(@user.id, "123").and_return(true)
      post :create, :task_id => @task.id, :assignee_id => 123
      response.should redirect_to("/dashboard")
    end

    it "should render edit form" do
      get :edit, :task_id => @task.id
      response.should be_success
      response.should render_template(:edit)
    end

    it "should call for assign! and redirect" do
      @task.should_receive(:assign_by_user_ids!).with(1, 2).and_return(true)
      put :update, :task_id => @task.id, :task => {:editor_id => 1, :assignee_id => 2}
      response.should redirect_to(task_path(@task))
    end

    it "should render action edit" do
      put :update, :task_id => @task.id, :task => {:editor_id => 1, :assignee_id => 1}
      response.should be_success
      response.should render_template(:edit)
    end
  end
end
