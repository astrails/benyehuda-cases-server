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
    return true if current_user.admin_or_editor?

    flash[:error] = _("You must be an admin or editor to access this page")
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

    flash[:error] = _("Only participant can see this page")
    redirect_to task_path(@task)
    return false
  end

  before_filter :set_localization_options
  def set_localization_options
    FastGettext.available_locales = AVAILABLE_LOCALES
    FastGettext.text_domain = 'app'
    super(:session_domain => true, :canonic_redirect => true)
  end

  alias :authenticate_translations_admin :require_admin

  before_filter :setup_will_paginate
  def setup_will_paginate
    WillPaginate::ViewHelpers.pagination_options[:previous_label] = s_('paginator - previous page|&laquo; Previous')
    WillPaginate::ViewHelpers.pagination_options[:next_label] = s_('paginator - previous page|Next &raquo;')
  end
end
