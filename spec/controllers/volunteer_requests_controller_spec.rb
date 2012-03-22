require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VolunteerRequestsController do
  setup :activate_authlogic

  describe "not logged in users" do
    [:new, :create, :update, :index, :show].each do |a|
      describe_action(a) do
        before(:each) do
          @params = {:id => 1}
        end
        it_should_require_login
      end
    end
  end

  describe "admin actions" do

    render_views

    before(:each) do
      @volunteer_request = Factory.create(:volunteer_request)
      @confirmed_volunteer_request = Factory.create(:confirmed_volunteer_request)
      @user = Factory.create(:admin)
      UserSession.create(@user)
    end

    it "should render index" do
      get :index
      response.should be_success
      response.should render_template(:index)
      assigns[:volunteer_requests].length.should == 1
    end

    it "should render show" do
      VolunteerRequest.should_receive(:find).with(@volunteer_request.id).and_return(@volunteer_request)
      get :show, :id => @volunteer_request.id
      response.should be_success
      response.should render_template(:show)
    end

    it "should approve" do
      @volunteer_request.approved_at.should be_blank
      ActionMailer::Base.deliveries = []
      ActionMailer::Base.deliveries.count.should == 0
      put :update, :id => @volunteer_request.id
      response.should redirect_to(volunteer_requests_path)
      @volunteer_request.reload.approved_at.should_not be_blank
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should not reapprove" do
      lambda {put :update, :id => @confirmed_volunteer_request.id}.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "logged in user" do
    before(:each) do
      @user = Factory.create(:active_user)
      UserSession.create(@user)
    end

    describe "protected actions" do
      [:update, :index, :show].each do |a|
        describe_action(a) do
          before(:each) do
            @params = {:id => 1}
          end
          it_should_redirect_to "/dashboard"
        end
      end
    end


    describe "user with volunteer request" do

      before(:each) do
        @user.create_volunteer_request(:preferences => "some long text")
        @user.should_not be_might_become_volunteer
      end

      it "should not render new" do
        get :new
        flash[:error].should =~ /Your request has already been posted/
        response.should redirect_to("/dashboard")
      end

      it "should not be able to create another one" do
        post :create, :volunteer_request => {:preferences => "some long text"}
        flash[:error].should =~ /Your request has already been posted/
        response.should redirect_to("/dashboard")
        assigns[:volunteer_request].should be_blank
      end
    end

    describe "user without volunteer request" do

      render_views

      before(:each) do
        @user.should be_might_become_volunteer
      end
      describe_action(:new) {it_should_render_template(:new)}

      it "should create request" do
        post :create, :volunteer_request => {:preferences => "some long text"}
        response.should redirect_to("/dashboard")
        @user.reload.volunteer_request.should_not be_blank
      end

      it "should render errors" do
        post :create
        response.should render_template(:new)
        assigns[:volunteer_request].errors.should_not be_blank
      end
    end
  end

end
