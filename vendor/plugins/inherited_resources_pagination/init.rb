require File.expand_path("../lib/inherited_resources/paginated_collection_helper", __FILE__)
unless defined?(SKIP_INHERITED_RESOURCES_PAGINATION_HELPER_INCLUDE)
  config.after_initialize { InheritedResources::Base.send :include, InheritedResources::PaginatedCollectionHelper }
end
