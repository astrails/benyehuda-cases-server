class TasksController < InheritedResources::Base
  before_filter :require_admin
  actions :index, :new, :create

  Task.aasm_states.collect(&:name).each do |name|
    has_scope name, :boolean => true, :only => :index
  end

  def create
    @task = current_user.created_tasks.create(params[:task])
    create! do |format|
      format.html {redirect_to tasks_path}
    end
  end

protected
  def collection
    @tasks ||= end_of_association_chain.by_updated_at.paginate(:page => params[:page], :per_page => params[:per_page])
  end
end
