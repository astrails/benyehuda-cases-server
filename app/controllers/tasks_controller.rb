class TasksController < InheritedResources::Base
  before_filter :require_task_participant
  actions :show, :update

  # show

  def update
    unless resource.allow_event_for?(params[:event], current_user)
      flash[:error] = "Sorry, you're not allowed to perfrom this operation"
      redirect_to task_path(resource)
      return false
    end

    resource.send(params[:event]) # all security verifications in verify_event
    resource.save

    # TODO: handle rejects with empty reason creating
    # TODO: handle new tasks (based on this one) creating

    flash[:notice] = "Task updated"
    redirect_to task_path(resource)
  end

protected
  def require_task_participant
    return false unless require_user
    return true if current_user.try(:is_admin?)
    return true if current_user.try(:is_editor?)
    return true if resource.participant?(current_user) # participant

    flash[:error] = "Only participant can see this page"
    redirect_to "/"
    return false
  end
end
