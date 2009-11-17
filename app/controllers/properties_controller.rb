class PropertiesController < InheritedResources::Base
  before_filter :require_admin

  # index
  # new

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

  def destroy
    super do |format|
      format.js do
        flash.delete :notice
        render(:update) do |page|
          page << "jQuery('##{dom_id(@property)}').remove();"
        end
      end
    end
  end

protected
  def collection
    @properties ||= end_of_association_chain.by_parent_type.by_title.paginate(:page => params[:page], :per_page => params[:per_page])
  end
  
end
