class WelcomeController < ApplicationController
  before_filter :not_logged_in_required

  def index
  end

protected
  def not_logged_in_required
    return redirect_to(dashboard_path) if logged_in?
  end
end
