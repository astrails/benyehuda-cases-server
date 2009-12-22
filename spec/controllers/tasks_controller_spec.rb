require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TasksController do
  setup :activate_authlogic
  integrate_views

  describe "reject" do
    before(:each) do
      @task = Factory.create(:waits_for_editor_approve_task)
      @user = @task.send(:editor)
      UserSession.create(@user)
    end

    it "should render invalid comment" do
      put :update, :id => @task.id, :event => "reject", :task => {:comment => {}}
      response.should be_success
      assigns[:task].rejection_comment.errors.on(:message).should_not be_blank
      response.should render_template("tasks/reject")
    end

    it "should redirect with ajax" do
      put :update, :id => @task.id, :event => "reject", :task => {:comment => {:message => "some comment"}}
      response.should be_success
      response.body =~ /window\.location\.href/
    end
  end

  describe "abandon" do
    before(:each) do
      @task = Factory.create(:assigned_task)
      UserSession.create(@task.assignee)
    end

    it "should render comment errors" do
      put :update, :id => @task.id, :event => "abandon", :task => {:comment => {}}
      response.should be_success
      response.should render_template("tasks/abandon")
      assigns[:task].abandoning_comment.errors.on(:message).should_not be_blank
    end

    it "should redirect with ajax" do
      put :update, :id => @task.id, :event => "abandon", :task => {:comment => {:message => "comment"}}
      response.body =~ /window\.location\.href/
      response.body =~ /dashboard/
    end
  end

  describe "access" do
    before(:each) do
      @task = Factory.create(:task)
      @comments = mock("comments")
      @comments.stub(:with_user).and_return(@comments)
      @task.stub!(:comments).and_return(@comments)
      Task.stub(:find).and_return(@task)
    end

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
