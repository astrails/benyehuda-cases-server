class SiteNoticesController < InheritedResources::Base
  before_filter :require_admin
  actions :index, :edit, :update, :destroy, :create
  # responds_to :js, :only => :update, :destroy

  # index
  # edit
  # update
  # destroy
  # create
end
