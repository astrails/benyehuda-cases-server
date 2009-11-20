class ApplicationController < ActionController::Base
  include Astrails::Auth::Controller

  def home_path; dashboard_path end
  helper_method :home_path

  helper :all
  protect_from_forgery
  filter_parameter_logging "password" unless Rails.env.development?
end
