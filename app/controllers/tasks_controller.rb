class TasksController < InheritedResources::Base
  before_filter :require_task_participant
  actions :show

  # show
  def show
    @task = Task.find(params[:id], :include => :documents)
    show!
  end

protected
  def require_task_participant
    return false unless require_user
    return true if current_user.try(:is_admin?)
    return true if current_user.try(:is_editor?)
    return true if @task.participant?(current_user) # participant

    flash[:error] = "Only participant can see this page"
    redirect_to "/"
    return false
  end
end
