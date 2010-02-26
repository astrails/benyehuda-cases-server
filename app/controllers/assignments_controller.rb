class AssignmentsController < ApplicationController
  before_filter :require_editor_or_admin, :set_task

  def create
    @task.assign_by_user_ids!(current_user.id, params[:assignee_id])
    flash[:notice] = _("Task has been reassigned")
    redirect_to dashboard_path
  end

  def edit
    @skip_assignment_links = true
  end

  def update
    @task.assign_by_user_ids!(params[:task][:editor_id], params[:task][:assignee_id])
    flash[:notice] = _("Task has been reassigned")
    redirect_to task_path(@task)
  rescue ActiveRecord::RecordInvalid
    render :action => "edit"
  end
end
