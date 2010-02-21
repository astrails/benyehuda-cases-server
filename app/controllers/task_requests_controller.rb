class TaskRequestsController < ApplicationController
  before_filter :require_volunteer

  def create
    current_user.task_requested_at = Time.now.utc
    current_user.save
    render(:update) do |page|
      page[:task_request].html render(:partial => "users/task_request")
    end
  end
end
