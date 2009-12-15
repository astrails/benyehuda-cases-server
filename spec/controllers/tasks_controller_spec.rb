require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TasksController do
  setup :activate_authlogic
  integrate_views

  before(:each) do
    @task = Factory.create(:task)
    @comments = mock("comments")
    @comments.stub(:with_user).and_return(@comments)
    @task.stub!(:comments).and_return(@comments)
    Task.stub(:find).and_return(@task)
  end

  describe "access" do
    it "should not allow access to anyone" do
      get :show, :id => @task.id
      response.should redirect_to("/login")
    end

    [:active_user, :another_volunteer].each do |u|
      it "#{u} should not have access to a task" do
        @user = Factory.create(u)
        UserSession.create(@user)
        get :show, :id => @task.id
        response.should redirect_to("/")
        flash[:error].should == "Only participant can see this page"
      end
    end
    [:editor, :creator, :assignee].each do |u|
      it "task's #{u} should have access to task" do
        @user = @task.send(u)
        UserSession.create(@user)
        if :assignee == u
          @comments.should_receive(:public)
        else
          @comments.should_receive(:all)
        end
        get :show, :id => @task.id
        response.should be_success
        response.should render_template(:show)
      end
    end
    [:admin, :editor].each do |u|
      it "another #{u} should have access to task" do
        @user = Factory.create(u)
        UserSession.create(@user)
        @comments.should_receive(:all)
        get :show, :id => @task.id
        response.should be_success
        response.should render_template(:show)
      end
    end
  end

end
