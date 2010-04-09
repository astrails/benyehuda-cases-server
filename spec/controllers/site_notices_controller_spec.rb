require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SiteNoticesController do
  setup :activate_authlogic
  
  describe "not admin" do
    before(:each) do
      @user = Factory.create(:user)
      UserSession.create(@user)
    end

    [:index, :update, :edit, :destroy, :create].each do |a|
      describe_action(a) do
        before(:each) do
          @params = {:id => 1}
        end
        it_should_require_login
      end
    end
  end

end
