class SiteNoticesController < InheritedResources::Base
  before_filter :require_admin
  actions :index, :edit, :update, :destroy, :create
  respond_to :js, :only => [:update, :destroy]

  # index

  # edit

  # destroy

  def create
    create! do |success, failure|
      success.html {redirect_to(site_notices_path)}
      failure.html
    end
  end

  def update
    update! do |success, failure|
      success.html {redirect_to(site_notices_path)}
      failure.html
    end
  end

protected
  def collection
    @collection ||= SiteNotice.send(params[:all] ? :all : :active).paginate(:page => params[:page], :per_page => params[:per_page])
  end
end
