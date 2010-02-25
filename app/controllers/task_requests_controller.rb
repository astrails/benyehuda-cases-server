class TaskRequestsController < ApplicationController
  before_filter :require_volunteer

  def create
    current_user.set_task_requested!
    render(:update) do |page|
      page[:task_request].html render(:partial => "users/task_request")
    end
  end
end
