class GlobalPreferencesController < InheritedResources::Base
  unloadable
  include InheritedResources::DSL
  before_filter :require_admin

  update! {collection_path}
  create! {collection_path}

end
