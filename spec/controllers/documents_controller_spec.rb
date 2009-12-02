require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DocumentsController do
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
      @document = mock_model(Document, :user_id => (@user.id + 1))
      @task.documents.stub!(:find).and_return(@document)
      UserSession.create(@user)
    end

    [:new, :destroy, :create].each do |a|
      describe_action(a) do
        before(:each) do
          @params = {:id => 1, :task_id => "1"}
        end
        it_should_redirect_to "/tasks/1"
      end
    end
  end

  describe "delete attachemnt" do
    it "owner shold be able to delete document" do
      @user = Factory.create(:active_user)
      @document = mock_model(Document, :user_id => @user.id)
      @task.documents.stub!(:find).and_return(@document)
      UserSession.create(@user)
      @document.should_receive(:deleted_at=).and_return(true)
      @document.should_receive(:save!).and_return(true)

      delete :destroy, :task_id => @task.id, :id => "1"
      response.should redirect_to(task_path(@task))
    end

    it "admin should be able to delete document even if didnt create it" do
      @user = Factory.create(:admin)
      @document = mock_model(Document, :user_id => (@user.id + 1))
      @task.documents.stub!(:find).and_return(@document)
      UserSession.create(@user)
      @document.should_receive(:deleted_at=).and_return(true)
      @document.should_receive(:save!).and_return(true)

      delete :destroy, :task_id => @task.id, :id => "1"
      response.should redirect_to(task_path(@task))
    end
  end

  describe "create attachment" do
    describe  "participants" do
      [:creator, :editor, :assignee].each do |u|
        before(:each) do
          @user = @task.send(u)
          UserSession.create(@user)
          @doc = mock_model(Document)
          @doc.should_receive(:user_id=).and_return(true)
          @doc.stub!(:save).and_return(false)
          @doc.stub!(:new_record?).and_return(true)
          @doc.errors.stub!(:empty?)
          @doc.errors.stub!(:on)
          @doc.errors.stub!(:[])
          @task.documents.stub!(:build).and_return(@doc)
          post :create, :task_id => "1", :document => {}
        end
        it "should render errors for #{u}" do
          response.should be_success
        end
      end
    end
    describe "others" do
      [:active_user, :another_volunteer].each do |user|
        before(:each) do
          @user = Factory.create(user)
          UserSession.create(@user)
        end

        it "should redirect with error" do
          post :create, :task_id => "1", :document => {}
          response.should redirect_to("/tasks/1")
          flash[:error].should == "Only participant can see this page"
        end
      end
    end
  end
end
