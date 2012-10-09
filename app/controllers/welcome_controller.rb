class WelcomeController < ApplicationController
  before_filter :not_logged_in_required, :only => :index

  def index
  end

  def byebye
    cookies.delete :user_credentials
    redirect_to login_path
  end

protected
  def not_logged_in_required
    return redirect_to(dashboard_path) if logged_in?
  end
end
