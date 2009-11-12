module Astrails
  module Auth
    module Controller
      def self.included(base)
        base.class_eval do
          helper_method :current_user, :current_user_session, :logged_in?
          helper_method :when_current_user, :when_regular_other_user, :when_other_user, :when_admin
          helper_method :when_current_user_or_admin, :when_logged_in, :when_not_logged_in, :same_user?
        end
      end
      def current_user_session
        defined?(@current_user_session) ? @current_user_session : @current_user_session = UserSession.find
      end

      def current_user
        defined?(@current_user) ? @current_user : @current_user = current_user_session.try(:user)
      end

      def current_user_admin?
        current_user.try(:is_admin)
      end

      def logged_in?
        !!current_user
      end

      def require_user
        return true if current_user

        store_location
        flash[:error] = "You must be logged in to access this page"
        redirect_to login_path
        return false
      end

      def require_no_user
        return true unless current_user

        store_location
        flash[:error] = "You must be logged out to access this page"
        redirect_to home_path
        return false
      end

      def require_admin
        return false if false == require_user
        return true if current_user.is_admin?

        flash[:error] = "You must be an admin to access this page"
        redirect_to "/"
        return false
      end

      def require_same_user
        return false if false == require_user

        if params[:user_id].blank? || (params[:user_id].to_i == current_user.id.to_i)
          @user = current_user
        else
          redirect_to "/"
          false
        end
      end

      def require_same_user_or_admin
        return false if false == require_user

        if params[:user_id].blank? || (params[:user_id].to_i == current_user.id.to_i)
          @user = current_user
        elsif current_user.is_admin?
          @user = User.find(params[:user_id])
        else
          redirect_to "/"
          false
        end
      end

      def store_location
        session[:return_to] = request.request_uri if request.get? # we can only return to GET locations
      end

      def redirect_back_or_default(default)
        redirect_to(session[:return_to] || default)
        session[:return_to] = nil
      end

      def when_current_user
        yield if (@user == current_user)
      end

      def when_current_user_or_admin
        yield if (@user == current_user) || current_user_admin?
      end

      def when_other_user
        yield if (@user != current_user)
      end

      def when_regular_other_user
        yield if (@user != current_user) && !current_user_admin?
      end

      def same_user?
        current_user && @user == current_user
      end

      def when_admin
        yield if current_user_admin?
      end

      def when_logged_in
        yield if logged_in?
      end

      def when_not_logged_in
        yield unless logged_in?
      end
    end
  end
end
