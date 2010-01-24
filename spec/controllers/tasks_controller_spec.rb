require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TasksController do
  setup :activate_authlogic
  integrate_views

  describe "unassigned tasks" do
    it "should not allow access to volunteer" do
      @user = Factory.create(:volunteer)
      UserSession.create(@user)
      get :index
      response.should redirect_to("/dashboard")
    end

    [:editor, :admin].each do |u|
      it "should render unassigned tasks for #{u}" do
        Factory.create(:task)
        @user = Factory.create(u)
        UserSession.create(@user)
        get :index
        response.should be_success
        response.body.should =~ /Unassigned/
      end
    end
  end

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

  describe "create child task" do
    it "should not allow changing task to volunteer" do
      @user = Factory.create(:volunteer)
      UserSession.create(@user)
      post :create, :id => 12
      response.should redirect_to("/dashboard")
    end

    it "should not allow creating child task when event is not in chain" do
      @user = Factory.create(:editor)
      UserSession.create(@user)
      @task = Factory.create(:task)
      xhr :post, :create, :id => @task.id
      response.flash[:error].should == "Sorry, you're not allowed to perfrom this operation"
      response.body.should == "window.location.href = \"/tasks/#{@task.id}\";"
    end

    describe "editor" do
      before(:each) do
        @task = Factory.create(:approved_task)
        UserSession.create(@task.editor)
      end

      it "should render errors on creation" do
        xhr :post, :create, :id => @task.id
        response.should be_success
        assigns[:chained_task].should be_new_record
        response.should render_template("new_chain_task")
      end

      it "should create chained task" do
        Task.stub!(:find).and_return(@task)
        chained_task = mock("chained_task", :id => 123, :to_param => "123")
        chained_task.stub!(:save).and_return(true)
        @task.should_receive(:build_chained_task).and_return(chained_task)
        xhr :post, :create, :id => @task.id, :task => {:name => "lalala"}
        response.should be_success
        response.body.should == "window.location.href = \"/tasks/123\";"
      end
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

  describe "update" do
    describe "assignee" do      
      before(:each) do
        @task = Factory.create(:assigned_task)
        UserSession.create(@task.assignee)
      end
      it "help_required" do
        put :update, :id => @task.id, :event => "help_required"
        response.should redirect_to(task_path(@task))
        @task.reload.state.should == "stuck"
      end

      it "finish_partially" do
        put :update, :id => @task.id, :event => "finish_partially"
        response.should redirect_to(task_path(@task))
        @task.reload.state.should == "partial"
      end

      it "finish" do
        put :update, :id => @task.id, :event => "finish"
        response.should redirect_to(task_path(@task))
        @task.reload.state.should == "waits_for_editor"
      end
    end

    describe "editor" do
      it "approve" do
        @task = Factory.create(:waits_for_editor_approve_task)
        UserSession.create(@task.editor)
        put :update, :id => @task.id, :event => "approve"
        response.should redirect_to(task_path(@task))
        @task.reload.state.should == "approved"
      end

      it "complete" do
        @task = Factory.create(:approved_task)
        UserSession.create(@task.editor)
        put :update, :id => @task.id, :event => "complete"
        response.should redirect_to(task_path(@task))
        @task.reload.state.should == "ready_to_publish"
      end
    end
  end

  describe "access" do
    before(:each) do
      @task = Factory.create(:task)
      @comments = mock("comments")
      @comments.stub(:with_user).and_return(@comments)
      @task.stub!(:comments).and_return(@comments)
      Task.stub!(:find).and_return(@task)
      @task.stub!(:children).and_return([])
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
