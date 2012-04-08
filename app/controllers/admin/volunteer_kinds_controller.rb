class Admin::VolunteerKindsController < InheritedResources::Base
  before_filter :require_admin
  actions :new, :create, :index, :destroy
  respond_to :js
end
