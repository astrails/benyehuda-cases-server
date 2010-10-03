class ApplicationController < ActionController::Base
  include Astrails::Auth::Controller

  helper :all
  protect_from_forgery
  filter_parameter_logging "password" unless Rails.env.development?

protected
  def default_index_with_search!
    begin
      index!
    rescue Riddle::ConnectionError
      flash[:error] = _("Search is not available at this moment, please try again later")
      redirect_to "/"
    end
  end

  def default_locale
    "he"
  end

  def detect_locale_from(source)
    case source
    when :params
      params[:locale]
    when :session
      session[:locale]
    when :cookie
      cookies[:locale]
    when :domain
      parse_host_and_port_for_locale[0]
    when :header, :default
      default_locale
    else
      raise "unknown source #{source}"
    end
  end

  def home_path; dashboard_path end
  helper_method :home_path

  def require_editor_or_admin
    return false if false == require_user
    return true if current_user.admin_or_editor?

    flash[:error] = _("You must be an admin or editor to access this page")
    redirect_to home_path
    return false
  end

  def require_volunteer
    return false if false == require_user
    return true if current_user.is_volunteer? || current_user.admin_or_editor?

    flash[:error] = _("You must be a volunteer to access this page")
    redirect_to home_path
    return false
  end

  def set_task
    @task = Task.find(params[:task_id])
  end

  def require_task_participant
    return false unless require_user
    return true if current_user.try(:is_admin?)
    return true if task.participant?(current_user) # participant

    flash[:error] = _("Only participant can see this page")
    redirect_to task_path(task)
    return false
  end

  before_filter :setup_localization
  def setup_localization
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
