class VolunteerRequestsController < InheritedResources::Base
  before_filter :require_user
  before_filter :require_editor_or_admin, :except => [:create, :new]
  before_filter :check_volunteer_request, :only => [:create, :new]
  actions :new, :create, :update, :index, :show

  # new

  def create
    @volunteer_request = current_user.create_volunteer_request(params[:volunteer_request])
    if @volunteer_request.new_record?
      render :action => "new"
      return
    end

    flash[:notice] = "Thank you, your request has been posted."
    redirect_to home_path
  end

  # index

protected
  def collection
    @volunteer_requests ||= end_of_association_chain.
      pending.
      by_request_time.
      with_user.
      paginate(:page => params[:page], :per_page => params[:per_page])
  end

  def check_volunteer_request
    return true if current_user.might_become_volunteer?

    flash[:error] = "Your request has already been posted."
    redirect_to home_path
  end
end
