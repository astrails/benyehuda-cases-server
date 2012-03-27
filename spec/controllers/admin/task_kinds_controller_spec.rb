require 'spec_helper'

describe Admin::TaskKindsController do
  render_views
  setup :activate_authlogic

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
        xhr :get, :new
        response.should render_template :new
      end
    end

    describe :create do
      it "should create task_kind" do
        lambda{
          xhr :post, :create, :task_kind => {:name => "foo"}
        }.should change(TaskKind, :count).by(1)
      end

      it "should render create" do
        xhr :post, :create, :task_kind => {:name => "foo"}
        response.should render_template :create
      end
    end

    describe :index do
      it "should render index" do
        xhr :get, :index
        response.should render_template :index
      end
    end

    describe :destroy do
      before(:each) do
        @task_kind = Factory.create(:task_kind)
      end

      it "should destroy task kind" do
        lambda{
          xhr :delete, :destroy, :id => @task_kind.id
        }.should change(TaskKind, :count).by(-1)
      end

      it "should render destroy" do
        xhr :delete, :destroy, :id => @task_kind.id
        response.should render_template :destroy
      end
    end
  end
end
