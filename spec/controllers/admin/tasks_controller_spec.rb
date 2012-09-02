require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::TasksController do

  setup :activate_authlogic

  [:active_user, :editor, :volunteer].each do |u|
    describe "not admin - #{u}" do
      before(:each) do
        @user = Factory.create(u)
        UserSession.create(@user)
      end

      [:edit, :update, :new, :update, :create, :destroy].each do |a|
        describe_action(a) do
          before(:each) do
            @params = {:id => 1}
          end
          it_should_redirect_to "/"
        end
      end
    end
  end

  describe "guest" do
    [:edit, :update, :new, :update, :create, :destroy].each do |a|
      describe_action(a) do
        before(:each) do
          @params = {:id => 1}
        end
        it_should_require_login
      end
    end
  end


  describe "admin" do

    render_views

    before(:each) do
      @user = Factory.create(:admin)
      @task = Factory.create(:task)
      @task_kind = Factory.create(:task_kind)
      UserSession.create(@user)
    end

    describe_action(:new) { it_should_render_template :new }

    it "should render index" do
      controller.current_user.search_settings.should_receive(:set_from_params!)
      get :index
      response.should be_success
      response.should render_template("index")
    end

    it "should render edit" do
      get :edit, :id => @task.id
      response.should be_success
      response.should render_template(:edit)
    end

    it "should update task" do
      put :update, :id => @task.id, :task => {:name => "new name"}
      response.should redirect_to(task_path(@task))
      @task.reload.name.should == "new name"
      put :update, :id => @task.id, :task => {:kind_id => @task_kind.id}
      response.should redirect_to(task_path(@task))
      @task.reload.kind.id.should == @task_kind.id
    end

    describe "changing states/assignees" do
      it "should allow changing states" do
        @task.state.should == "unassigned"
        put :update, :id => @task.id, :task => {:admin_state => "partial"}
        response.should redirect_to(task_path(@task))
        @task.reload.should be_partial
      end

      it "should not allow changing states" do
        @task = Factory.create(:unassigned_task)
        put :update, :id => @task.id, :task => {:admin_state => "partial"}
        response.should be_success
        response.should render_template(:edit)
        assigns[:task].errors.on(:assignee).should_not be_blank
        assigns[:task].errors.on(:editor).should_not be_blank
        @task.reload.should be_unassigned
      end

      it "should allow to change assignees" do
        put :update, :id => @task.id, :task => {:assignee_id => 12}
        response.should redirect_to(task_path(@task))
        @task.reload.assignee_id.should == 12
      end

      it "should allow to change editors" do
        put :update, :id => @task.id, :task => {:editor_id => 22}
        response.should redirect_to(task_path(@task))
        @task.reload.editor_id.should == 22
      end
    end

    it "should create a task" do
      post :create, :task => {:name => "oops", :kind_id => Factory.create(:task_kind, :name => "typing").id}
      response.should redirect_to("/tasks/#{Task.last.id}")
      Task.last.name.should == "oops"
      Task.last.should be_unassigned
      Task.last.creator_id.should == @user.id
    end

    it "should create a task with assignee, editor and state" do
      post :create, :task => {
        :name => "oopsoops",
        :assignee_id => 12,
        :editor_id => 125,
        :admin_state => "rejected",
        :kind_id => Factory.create(:task_kind, :name => "typing").id
      }
      response.should redirect_to("/tasks/#{Task.last.id}")
      Task.last.name.should == "oopsoops"
      Task.last.should be_rejected
      Task.last.assignee_id.should == 12
      Task.last.editor_id.should == 125
    end

    describe :destroy do
      it "should delete a task" do
        lambda{
          xhr :delete, :destroy, :id => @task.id
          response.should render_template :destroy
        }.should change(Task, :count).by(-1)
      end
    end
  end
end
