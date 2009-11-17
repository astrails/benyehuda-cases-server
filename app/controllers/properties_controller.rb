class PropertiesController < InheritedResources::Base
  before_filter :require_admin
  actions :index, :new, :destroy, :create, :update, :edit

  # index
  # new
  # destory
  # edit

  def create
    super do |format|
      format.html {redirect_to properties_path}
    end
  end

  def update
    super do |format|
      format.html {redirect_to properties_path}
    end
  end

protected
  def collection
    @properties ||= end_of_association_chain.by_parent_type.by_title.paginate(:page => params[:page], :per_page => params[:per_page])
  end
  
end
