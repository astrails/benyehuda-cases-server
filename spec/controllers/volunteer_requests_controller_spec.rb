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
        @user.create_volunteer_request(:reason => "some long text")
        @user.should_not be_might_become_volunteer
      end

      it "should not render new" do
        get :new
        flash[:error].should =~ /Your request has already been posted/
        response.should redirect_to("/dashboard")
      end

      it "should not be able to create another one" do
        post :create, :volunteer_request => {:reason => "some long text"}
        flash[:error].should =~ /Your request has already been posted/
        response.should redirect_to("/dashboard")
        assigns[:volunteer_request].should be_blank
      end
    end

    describe "user without volunteer request" do

      integrate_views

      before(:each) do
        @user.should be_might_become_volunteer
      end
      describe_action(:new) {it_should_render_template(:new)}

      it "should create request" do
        post :create, :volunteer_request => {:reason => "some long text"}
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
