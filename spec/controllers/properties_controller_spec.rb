require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PropertiesController do
  setup :activate_authlogic

  describe "not admin" do
    before(:each) do
      @user = Factory.create(:user)
      UserSession.create(@user)
    end

    [:edit, :destroy, :create].each do |a|
      describe_action(a) do
        before(:each) do
          @params = {:id => 1}
        end
        it_should_require_login
      end
    end
    describe_action(:new) { it_should_require_login }
    describe_action(:index) { it_should_require_login }
  end

  describe "admin" do
    render_views

    before(:each) do
      @admin = Factory.create(:admin)
      UserSession.create(@admin)
      @property = Factory.create(:property)
      Property.stub(:find).with(@property.id.to_s).and_return(@property)
      Property.stub!(:paginate).and_return[@property, @property]
    end

    describe_action(:new) { it_should_render_template :new }
    describe_action(:index) { it_should_render_template :index }

    it "should render edit" do
      get :edit, :id => @property.id
      response.should be_success
    end

    it "should destroy property" do
      delete :destroy, :id => @property.id
      response.should redirect_to(properties_path)
    end

    it "should update" do
      put :update, :id => @property.id, :property => {:title => "new one"}
      response.should redirect_to(properties_path)
      @property.title.should == "new one"
    end

    it "should create" do
      post :create, :property => {:title => "new one", :parent_type => "Editor", :property_type => "string", :comment => "some comment"}
      assigns[:property].should_not be_blank
      response.should redirect_to(properties_path)
    end
  end
end
