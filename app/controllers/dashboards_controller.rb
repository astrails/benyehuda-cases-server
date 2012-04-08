class DashboardsController < InheritedResources::Base
  before_filter :require_user
  defaults :resource_class => Task, :collection_name => 'tasks', :instance_name => 'task'
  has_scope :order_by, :only => :index, :using => [:includes, :property, :dir]
  has_scope :order_by_state, :only => :index, :using => [:dir]
  actions :index

  def index
    @waiting_volunteers = User.all_volunteers.waiting_for_tasks.all if current_user.admin_or_editor?
    super
  end

  protected

  def collection
    @tasks ||= apply_scopes(current_user.assigned_tasks).visible_in_my_tasks.paginate(:page => params[:page], :per_page => params[:per_page])
  end
end
