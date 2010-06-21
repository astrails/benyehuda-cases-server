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
    after(:each) do
      @task.documents.stub!(:find).and_return(@document)
      UserSession.create(@user)
      @document.should_receive(:mark_as_deleted!).and_return(true)

      delete :destroy, :task_id => @task.id, :id => "1"
      response.should redirect_to(task_path(@task))
    end

    it "owner shold be able to delete document" do
      @user = Factory.create(:active_user)
      @document = mock_model(Document, :user_id => @user.id)
    end

    it "admin should be able to delete document even if didnt create it" do
      @user = Factory.create(:admin)
      @document = mock_model(Document, :user_id => (@user.id + 1))
    end
  end

  describe "create attachment" do
    [:creator, :editor, :assignee].each do |u|
      describe  "participants - #{u} -" do
        before(:each) do
          @user = @task.send(u)
          UserSession.create(@user)
        end

        it "should render errors" do
          @doc = mock_model(Document)
          @doc.errors.stub!(:empty?)
          @doc.errors.stub!(:on)
          @doc.errors.stub!(:[])
          @doc.stub!(:save).and_return(false)
          @doc.stub!(:new_record?).and_return(true)
          @task.should_receive(:prepare_document).and_return(@doc)
          xhr :post, :create, :task_id => "1", :document => {}
          response.status.should == "422 Unprocessable Entity"
        end

        it "should render new doc for #{u}" do
          @doc = Factory.build(:document)
          @doc.stub!(:save).and_return(true)
          @doc.stub!(:image?).and_return(false)
          @doc.stub!(:new_record?).and_return(false)
          @doc.stub!(:to_param).and_return("123")
          @doc.stub!(:user).and_return(Factory.build(:user))
          @doc.stub!(:file).and_return(mock("url", :url => "foobar"))
          @task.should_receive(:prepare_document).and_return(@doc)
          xhr :post, :create, :task_id => "1", :document => {}
          response.should be_success
          response.should render_template("documents/_document.html.haml")
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
