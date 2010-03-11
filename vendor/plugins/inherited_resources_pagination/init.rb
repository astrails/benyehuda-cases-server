require 'inherited_resources/paginated_collection_helper'
require 'dispatcher'
::Dispatcher.to_prepare { InheritedResources::Base.send :include, InheritedResources::PaginatedCollectionHelper }

