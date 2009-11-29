require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::TasksController do

  setup :activate_authlogic

  [:active_user, :editor, :volunteer].each do |u|
    describe "not admin - #{u}" do
      before(:each) do
        @user = Factory.create(u)
        UserSession.create(@user)
      end

      [:edit, :update, :new, :update, :create].each do |a|
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
    [:edit, :update, :new, :update, :create].each do |a|
      describe_action(a) do
        before(:each) do
          @params = {:id => 1}
        end
        it_should_require_login
      end
    end
  end


  describe "admin" do

    integrate_views

    before(:each) do
      @user = Factory.create(:admin)
      @task = Factory.create(:task)
      UserSession.create(@user)
    end

    describe_action(:new) { it_should_render_template :new }
    describe_action(:index) { it_should_render_template :index }
    # describe_action(:create ) { it_should_redirect_to("/admin/tasks")}
    
    it "should render edit" do
      get :edit, :id => @task.id
      response.should be_success
      response.should render_template(:edit)
    end

    it "should update task" do
      put :update, :id => @task.id, :task => {:name => "new name"}
      response.should redirect_to("/admin/tasks")
      @task.reload.name.should == "new name"
    end

    it "should create a task" do
      post :create, :task => {:name => "oops"}
      response.should redirect_to("/admin/tasks")
      Task.last.name.should == "oops"
      Task.last.creator_id.should == @user.id
    end
  end
end
