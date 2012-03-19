require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  setup :activate_authlogic
  before(:each) {@param = @factory = :user}

  describe "(guest)" do
    [:index, :show, :update, :destroy].each do |action|
      describe_action(action) do
        it_should_redirect_to "/login"
      end
    end

    describe_action :new do

      it_should_render_template :new
      it_should_assign :user
      it "shold initialize user with params"
      it "should not render password from params"
    end

    describe_action :create do

      describe "with empty form" do
        before(:each) do
          @params = {}
        end
        it_should_render_template :new
        it_should_assign :user
        it "shold initialize user with params"
      end

      describe "with valid form" do
        it "should_initialize_and_save :user"
        it "should flash :notice" do
          eval_request
          flash[:notice].should_not be_nil
        end
        it_should_redirect_to "/"

        it "should create admin if no other users" do
          User.should_receive(:count).and_return(0)
          eval_request
          User.last.should be_is_admin
        end

        it "should not create admin if there are other users" do
          User.should_receive(:count).and_return(1)
          eval_request
          User.last.should_not be_is_admin
        end
      end

    end
  end


  describe "volunteer" do
    render_views

    before(:each) do
      @user = Factory.create(:volunteer)
      UserSession.create(@user)
    end

    it "should be able to see own profile" do
      get :show, :id => @user.id, :public_profile => true
      response.should be_success
    end
  end

  describe "editor" do
    render_views

    before(:each) do
      @user = Factory.create(:editor)
      UserSession.create(@user)
      @string_property = Factory.create(:property)
      @bool_property = Factory.create(:bool_property)
      @text_property = Factory.create(:text_property)
    end

    describe "profile" do
      it "should render edit profile with custom properties" do
        get :edit, :id => @user.id
        response.should be_success
        response.should render_template "layouts/_properties_form"
        response.body.should match /user_editor_properties_#{@string_property.id}__custom_value_input/
        response.body.should =~ /user_editor_properties_#{@bool_property.id}__custom_value_input/
        response.body.should =~ /user_editor_properties_#{@text_property.id}__custom_value_input/
      end

      it "should update" do
        put :update, :id => @user.id, :user => {:editor_properties => {
            @string_property.id => {:custom_value => "s"},
            @bool_property.id => {:custom_value => "1"},
            @text_property.id => {:custom_value => "t"}
            }
          }
        response.should redirect_to(user_path(@user))
        @user.reload
        @user.editor_properties.find_by_property_id(@string_property.id).custom_value.should == "s"
        @user.editor_properties.find_by_property_id(@text_property.id).custom_value.should == "t"
        @user.editor_properties.find_by_property_id(@bool_property.id).custom_value.should == "1"
      end
    end

    describe "profile properties" do
      it "should render editable properties - not empty" do
        @user.update_attribute(:editor_properties, {
          @string_property.id => {:custom_value => "string"},
          @bool_property.id => {:custom_value => "1"},
          @text_property.id => {:custom_value => "text"},
        })
        get :edit, :id => @user.id
        response.should be_success

        response.should have_tag("input[type=text][name=?][value=?]", "user[editor_properties[#{@string_property.id}]][custom_value]", "string")
        response.should have_tag("input[type=checkbox][name=?][checked=checked]", "user[editor_properties[#{@bool_property.id}]][custom_value]")
        response.should have_tag("textarea[name=?]", "user[editor_properties[#{@text_property.id}]][custom_value]", /text/)
      end

      it "should render empty properties" do
        get :edit, :id => @user.id
        response.should be_success

        response.should have_tag("input[type=text][name=?]", "user[editor_properties[#{@string_property.id}]][custom_value]")
        response.should have_tag("input[type=checkbox][name=?]", "user[editor_properties[#{@bool_property.id}]][custom_value]", "")
        response.should have_tag("textarea[name=?]", "user[editor_properties[#{@text_property.id}]][custom_value]", "")
      end
    end
  end

  # describe "regular user" do
  #   stub_current_user
  #
  #   describe_action :index  do
  #     stubs_for_index(:user)
  #     it_should_render_template :index
  #     it "needs more tests"
  #   end
  #
  #   describe_action :new do
  #     it_should_redirect_to("/home") {"/home"}
  #     it_should_match(:flash, :error, /logged out/i)
  #   end
  #
  #   describe_action :create do
  #     it_should_redirect_to("/home") {"/home"}
  #     it_should_match(:flash, :error, /logged out/i)
  #   end
  #
  #   describe "accessing other profile" do
  #     with_other_user :param_name => :id
  #
  #     [:update, :destroy].each do |action|
  #       describe_action(action) do
  #         it_should_redirect_to("/") {"/"}
  #         it_should_match(:flash, :error, /owner/i)
  #       end
  #     end
  #   end
  #
  #   describe "assessing own profile" do
  #     with_current_user :param_name => :id
  #
  #     describe_action(:show) do
  #       it_should_render_template "show"
  #       it_should_find :user
  #       it_should_assign :user
  #     end
  #
  #     describe_action(:update) do
  #       describe "when successfull" do
  #         stubs_for_update(:user)
  #
  #         it_should_find :user
  #         it_should_update :user
  #         it_should_redirect_to("user_path(@user)") {user_path(@user)}
  #         it_should_match(:flash, :notice, /success/i)
  #       end
  #
  #       describe "when unsuccessfull" do
  #         stubs_for_update(:user, false)
  #         it_should_find :user
  #         it_should_assign :user
  #         it_should_update :user
  #         it_should_render_template "show"
  #         it_should_match(:flash_now, :notice, /fail/i)
  #       end
  #     end
  #
  #     describe_action(:destroy) do
  #       describe "when successfull" do
  #         stubs_for_destroy(:user)
  #
  #         it_should_find :user
  #         it_should_destroy :user
  #         it_should_redirect_to("/users") {users_path}
  #         #it_should_logout
  #         it "should logout" do
  #           eval_request
  #           session["user_credentials"].should be_nil
  #         end
  #       end
  #       describe "when unsuccessfull" do
  #         stubs_for_destroy(:user, false)
  #
  #         it_should_match(:flash, :notice, /fail/i)
  #         it_should_redirect_to("/users") {users_path}
  #       end
  #     end
  #
  #   end
  #
  # end
  #
  # describe "admin" do
  #   stub_current_user(:is_admin => true)
  #
  #   describe_action :index do
  #     stubs_for_index(:user)
  #     it_should_render_template "index"
  #     it_should_paginate_and_assign :users
  #   end
  # end
end
