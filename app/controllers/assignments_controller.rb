class AssignmentsController < ApplicationController
  before_filter :require_editor_or_admin, :set_task

  def edit
    @skip_assignment_links = true
  end

  def update
    @task.assign_by_user_ids!(params[:task][:editor_id], params[:task][:assignee_id])
    flash[:notice] = "Task has been reassigned"
    redirect_to task_path(@task)
  rescue ActiveRecord::RecordInvalid
    render :action => "edit"
  end

protected
  def set_task
    @task = Task.find(params[:task_id])
  end
end
