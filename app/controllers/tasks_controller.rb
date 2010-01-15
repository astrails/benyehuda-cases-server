class TasksController < InheritedResources::Base
  before_filter :require_task_participant_or_editor, :only => [:show, :update]
  before_filter :require_editor_or_admin, :only => :index
  actions :index, :show, :update

  EVENTS_WITH_COMMENTS = {"reject" => N_("Task rejected"), "abandon" => N_("Task abandoned")}

  def index
    @tasks = Task.unassigned.paginate(:page => params[:page], :per_page => params[:per_page])
  end

  def show
    @task = Task.find(params[:id], :include => {:documents => :user})
    @comments = @task.comments.with_user.send(current_user.admin_or_editor? ? :all : :public)
    show!
  end

  def update
    unless resource.allow_event_for?(params[:event], current_user)
      flash[:error] = _("Sorry, you're not allowed to perfrom this operation")
      redirect_to task_path(resource)
      return false
    end

    # all security verifications passed in allow_event_for?
    return _event_with_comment(params[:event]) if EVENTS_WITH_COMMENTS.keys.member?(params[:event])

    # TODO: handle new tasks (based on this one) creating

    resource.send(params[:event])
    resource.save

    flash[:notice] = _("Task updated")

    if resource.participant?(current_user)
      redirect_to task_path(resource)
    else
      redirect_to dashboard_path
    end
  end

protected
  def require_task_participant_or_editor
    return false unless require_user
    return true if current_user.admin_or_editor?
    return true if resource.participant?(current_user) # participant

    flash[:error] = _("Only participant can see this page")
    redirect_to "/"
    return false
  end

  def _event_with_comment(event)
    unless resource.send("#{event}_with_comment", params[:task][:comment][:message])
      render(:update) do |page|
        page[:abandon_task].html render(:partial => "tasks/#{event}")
      end
      return
    end

    resource.save
    flash[:notice] = s_(EVENTS_WITH_COMMENTS[event])
    render(:update) do |page|
      page.redirect_to(resource.participant?(current_user) ? task_path(resource) : dashboard_path)
    end    
  end
end
