class DashboardsController < InheritedResources::Base
  before_filter :require_user
  actions :show

  def show
  end

end
