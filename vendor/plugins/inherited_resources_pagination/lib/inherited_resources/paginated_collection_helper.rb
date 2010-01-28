# not defying InheritedResources on purpose. This one MUST be
# loaded AFTER the original InheritedResources
module InheritedResources::PaginatedCollectionHelper
  protected

  def collection
    get_collection_ivar ||
      set_collection_ivar(end_of_association_chain.paginate(:page => params[:page], :per_page => params[:per_page]))
  end
end
