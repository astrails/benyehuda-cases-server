class DocumentsController < InheritedResources::Base
  belongs_to :task
  before_filter :set_task
  before_filter :require_task_participant, :only => [:new, :create]
  before_filter :require_owner, :only => :destroy
  actions :new, :create, :destroy

  # new - shouldn't be used

  # create
  def create
    @document = @task.documents.build(params[:document])
    @document.user_id = current_user.id
    create! do |success, failure|
      success.js do
        render(:update) do |page|
          page[:documents].append render(:partial => "documents/document", :object => @document)
          page[:no_docs_uploaded].remove
        end
      end
      success.html {redirect_to task_path(@task)}
      failure.js do
        render :status => :unprocessable_entity, :nothing => true
      end
    end
  end

  def destroy
    document = @task.documents.find(params[:id])
    document.deleted_at = Time.now.utc
    document.save!
    flash[:notice] = _("Document deleted")
    redirect_to task_path(@task)
  end

protected
  def require_owner
    return false unless require_user
    return true if current_user.try(:is_admin?)
    return true unless resource # let it fail
    return true if resource.user_id == current_user.id # owner

    flash[:error] = _("Only the owner can see this page")
    redirect_to task_path(@task)
    return false
  end
end
