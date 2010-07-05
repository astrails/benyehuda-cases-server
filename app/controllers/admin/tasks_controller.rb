class Admin::TasksController < InheritedResources::Base
  before_filter :require_admin
  actions :index, :new, :create, :edit, :update

  def create
    params[:task].trust(:admin_state, :editor_id, :assignee_id)
    @task = current_user.created_tasks.create(params[:task])
    create! do |format|
      format.html do
        redirect_to (params[:commit] == _("Save and New")) ? new_admin_task_path : task_path(@task)
      end
    end
  end

  def update
    super do |format|
      format.html {redirect_to admin_tasks_path}
    end
  end

  def update
    params[:task].trust(:admin_state, :editor_id, :assignee_id)
    update! do |success, failure|
      success.html {redirect_to task_path(resource)}
    end
  end

  def index
    if "true" == params[:all]
      # reset
      current_user.search_settings.clear!
    elsif (params.keys & Task::SEARCH_KEYS).blank?
      # load defaults
      params.merge!(current_user.search_settings.load)
    end
    current_user.search_settings.set_from_params!(params)
    index!
  end

protected
  def collection
    @tasks ||= Task.filter(params).paginate(:page => params[:page], :per_page => params[:per_page])
  end

  def interpolation_options
    { :task_name => @task.name }
  end
end
