class UserSessionController < InheritedResources::Base
  unloadable
  actions :new, :create, :destroy
  before_filter :require_user, :only => :destroy
  defaults :singleton => true

  def create
    create! do |success, failure|
      success.html {redirect_to home_path}
    end
  end

  def destroy
    destroy! do |wants|
      wants.html {redirect_to login_path}
    end
  end

  private
  def resource
    @object ||= current_user_session
  end

end
