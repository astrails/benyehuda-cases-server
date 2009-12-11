class ApplicationController < ActionController::Base
  include Astrails::Auth::Controller

  helper :all
  protect_from_forgery
  filter_parameter_logging "password" unless Rails.env.development?

protected
  def home_path; dashboard_path end
  helper_method :home_path

  def require_editor_or_admin
    return false if false == require_user
    return true if current_user.is_editor? || current_user.is_admin?

    flash[:error] = "You must be an admin or editor to access this page"
    redirect_to home_path
    return false
  end

  def set_task
    @task = Task.find(params[:task_id])
  end

  def require_task_participant
    return false unless require_user
    return true if current_user.try(:is_admin?)
    return true if @task.participant?(current_user) # participant

    flash[:error] = "Only participant can see this page"
    redirect_to task_path(@task)
    return false
  end

end
