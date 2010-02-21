class DashboardsController < InheritedResources::Base
  before_filter :require_user
  actions :show

  def show
    @waiting_volunteers = User.all_volunteers.waiting_for_tasks.all if current_user.admin_or_editor?
  end

end
