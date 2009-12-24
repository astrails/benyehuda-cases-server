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


  before_filter :set_localization_options
  def set_localization_options
    FastGettext.available_locales = AVAILABLE_LOCALES
    FastGettext.text_domain = 'app'
    super(:session_domain => true, :canonic_redirect => true)
  end

  alias :authenticate_translations_admin :require_admin

end
