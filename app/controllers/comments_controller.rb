class CommentsController < InheritedResources::Base
  belongs_to :task
  before_filter :require_task_participant

  actions :create

  def create
    @comment = task.comments.build(params[:comment])
    @comment.user = current_user
    create! do |success, failure|
      success.js {
        render(:update) do |page|
          page[:comments].append render(:partial => "comment", :object => @comment)
          @comment = nil
          page[:new_comment].html render(:partial => "new")
        end
      }
      failure.js {
        render(:update) do |page|
          page[:new_comment].html render(:partial => "new")
        end
      }
    end
    flash[:notice] = nil
  end

protected
  def task
    @task ||= association_chain.last
  end
end
