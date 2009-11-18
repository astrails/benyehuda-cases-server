class UsersController < InheritedResources::Base
  before_filter :require_admin, :only => [:index, :destroy]
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_owner, :except => [:new, :create, :index]
  before_filter :set_default_domain, :only => :create

  def create
    user = build_resource
    user.is_admin = true if User.count.zero?
    if user.save_without_session_maintenance
      user.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to "/"
    else
      render :action => :new
    end
  end

  def update
    @user = User.find(params[:id])
    # manual update protected attributes
    if current_user.is_admin?
      @user.is_admin = params[:user].delete(:is_admin)
      @user.is_volunteer = params[:user].delete(:is_volunteer)
      @user.is_editor = params[:user].delete(:is_editor)
    end
    update!
  end

  def destroy
    @user = User.enabled.find(params[:id])
    if @user.id == current_user.id
      flash[:error] = "You cannot remove your own account"
      redirect_to users_path
      return
    end
    @user.update_attribute(:disabled_at, Time.now.utc)
    flash[:notice] = "User disabled"
    redirect_to users_path
  end

  protected

  def require_owner
    return false unless require_user
    return true unless resource # let it fail
    return true if current_user.try(:is_admin?)
    return true if resource == current_user # owner

    flash[:error] = "Only the owner can see this page"
    redirect_to "/"
    return false
  end

  def collection
    @users ||= end_of_association_chain.send("true" == params[:all] ? :all : :enabled).paginate(:page => params[:page], :per_page => params[:per_page])
  end

  def resource
    @user ||= params[:id] ? User.find(params[:id]) : current_user
  end

  def build_resource
    params[:user].try(:trust, :email)
    super
  end

  # this will set global preference :domain to the current domain
  # when we create the first user.
  def set_default_domain
    if GlobalPreference.get(:domain).blank?
      GlobalPreference.set!(:domain, request.host_with_port)
    end
  end
end
