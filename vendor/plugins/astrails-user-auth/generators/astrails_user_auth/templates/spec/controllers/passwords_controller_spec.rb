require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordsController do
  setup :activate_authlogic
  before(:each) {@param = @factory = :user}

  describe :routing do
    it_should_not_route :index
    it_should_not_route :show
    it_should_not_route :destroy
  end

  describe "(guest)" do
    describe_action(:new) { it_should_render_template "new" }

    describe_action(:create) do
      describe "w/o valid email" do
        it_should_render_template "new"
        it "should flash error" do
          eval_request
          flash[:error].should match(/no.*found/i)
        end
      end

      describe "with valid email" do
        before(:each) do
          @user = Factory.build(:user)
          @user.stub!(:deliver_password_reset_instructions!)
          @params = {:user => {:email => @user.email}}
          User.stub!(:find_by_email).with(@user.email).and_return(@user)
        end

        it_should_redirect_to "/"
        it "should set flash notice" do
          eval_request
          flash[:notice].should match(/Instructions .* emailed to you/)
        end

        it "should find user" do
          User.should_receive(:find_by_email).with(@user.email).and_return(@user)
          eval_request
          assigns[:user].should == @user
        end

        it "should call deliver_password_reset_instructions!" do
          @user.should_receive(:deliver_password_reset_instructions!)
          eval_request
        end
      end
    end

    describe "without token" do
      [:edit, :update].each do |action|
        describe_action(action) do
          before(:each) {@params = {}}
          it_should_redirect_to "/passwords/new"
          it "should flash error" do
            eval_request
            flash[:error].should match(/no.*locate/i)
          end
        end
      end
    end

    describe "with token" do
      before(:each) do
        @user = Factory.build(:user)
        @params = {:id => "some-token"}
        User.stub!(:find_using_perishable_token).with("some-token").and_return(@user)
      end

      describe_action(:edit) do
        it_should_render_template "edit"
        it "should_find user" do
          User.should_receive(:find_using_perishable_token).with("some-token").and_return(@user)
          eval_request
        end
      end

      describe_action(:update) do
        describe "when passwords don't match" do
          before(:each) do
            @params[:user] = {:password => "qweqwe", :password_confirmation => "asdasd"}
          end

          it "should find user" do
            User.should_receive(:find_using_perishable_token).with("some-token").and_return(@user)
            eval_request
            assigns[:user].should == @user
          end
          it_should_render_template "edit"
        end

        describe "when passwords match" do
          before(:each) do
            @params[:user] = {:password => "asdasd", :password_confirmation => "asdasd"}
            @user.stub!(:deliver_password_reset_confirmation!)
          end

          it "should_find user" do
            User.should_receive(:find_using_perishable_token).with("some-token").and_return(@user)
            eval_request
          end

          it "should send confirmation email" do
            @user.should_receive(:deliver_password_reset_confirmation!)
            eval_request
          end

          it "should update password" do
            @user.should_receive(:update_attributes).with(
              "password" => "asdasd",
              "password_confirmation" => "asdasd"
            ).and_return(true)
            eval_request
          end

          it_should_redirect_to("profile_path") {profile_path}
          it "should flash notice" do
            eval_request
            flash[:notice].should match(/updated/i)
          end
        end

      end
    end
  end

  describe "(user)" do
    before(:each) do
      UserSession.create!(@user = Factory.build(:active_user))
      @params = {}
    end

    [:new, :create].each do |action|
      describe_action(action) do
        it_should_redirect_to("/")
      end
    end

    describe_action(:edit) do
      it "should call current_user" do
        controller.should_receive(:current_user).and_return(@user)
        eval_request
      end

      it "should use current_user" do
        eval_request
        assigns[:user].should == @user
      end

    end

    describe_action(:update) do
      before(:each) do
        @params[:user] = {:password => "asdasd", :password_confirmation => "asdasd"}
        User.any_instance.stubs(:deliver_password_reset_confirmation!)
      end

      it "should call current_user" do
        controller.should_receive(:current_user).and_return(@user)
        eval_request
      end

      it "should use current_user" do
        eval_request
        assigns[:user].should == @user
      end

    end
  end

end