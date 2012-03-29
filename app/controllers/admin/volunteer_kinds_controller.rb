class Admin::VolunteerKindsController < InheritedResources::Base
  before_filter :require_admin
  actions :new, :create, :index, :destroy

  protected

  def collection
    @volunteer_kinds ||= super.paginate(:page => params[:page], :per_page => 25)
  end
end
