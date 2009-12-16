class TasksController < InheritedResources::Base
  before_filter :require_task_participant_or_editor
  actions :show, :update

  def show
    @task = Task.find(params[:id], :include => {:documents => :user})
    @comments = @task.comments.with_user.send(current_user.admin_or_editor? ? :all : :public)
    show!
  end

  def update
    unless resource.allow_event_for?(params[:event], current_user)
      flash[:error] = "Sorry, you're not allowed to perfrom this operation"
      redirect_to task_path(resource)
      return false
    end

    # all security verifications passed in allow_event_for?

    return _reject_task if "reject" == params[:event]
    # TODO: handle new tasks (based on this one) creating

    resource.send(params[:event])
    resource.save

    flash[:notice] = "Task updated"
    redirect_to task_path(resource)
  end

protected
  def require_task_participant_or_editor
    return false unless require_user
    return true if current_user.admin_or_editor?
    return true if resource.participant?(current_user) # participant

    flash[:error] = "Only participant can see this page"
    redirect_to "/"
    return false
  end

  def _reject_task
    unless resource.reject_with_comment(params[:task][:comment][:message])
      render(:update) do |page|
        page[:reject_task].html render(:partial => "tasks/reject")
      end
      return
    end

    resource.save
    flash[:notice] = "Task updated"
    render(:update) do |page|
      page.redirect_to task_path(resource)
    end
  end
end
