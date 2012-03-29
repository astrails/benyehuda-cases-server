require 'spec_helper'

describe Admin::VolunteerKindsController do
  describe "guest" do
    [:new, :create, :index, :destroy].each do |a|
      describe_action(a) do
        before(:each) do
          @params = {:id => 1}
        end
        it_should_require_login
      end
    end
  end

  describe :admin do
    before(:each) do
      @user = Factory.create(:admin)
      UserSession.create(@user)
    end

    describe :new do
      it "should render new" do
        get :new
        response.should render_template :new
      end
    end

    describe :create do
      it "should create volunteer_kind" do
        lambda{
          post :create, :volunteer_kind => {:name => "bar"}
          response.should redirect_to :index
        }.should change(VolunteerKind, :count).by(1)
      end
    end

    describe :index do
      it "should render index" do
        get :index
        response.should render_template :index
      end
    end

    describe :delete do
      before(:each) do
        @volunteer_kind = Factory.create(:volunteer_kind)
      end

      it "should destroy task kind" do
        lambda{
          delete :destroy, :id => @volunteer_kind.id
          response.should redirect_to :index
        }.should change(VolunteerKind, :count).by(-1)
      end
    end
  end
end
