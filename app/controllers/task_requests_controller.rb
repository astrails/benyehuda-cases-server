class TaskRequestsController < ApplicationController
  before_filter :require_volunteer

  def create
    current_user.set_task_requested.save!
    render(:update) do |page|
      page[:task_request].html render(:partial => "users/task_request.html.haml")
    end
  end
end
