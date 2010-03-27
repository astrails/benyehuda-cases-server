class UsersController < InheritedResources::Base
  before_filter :require_admin, :only => [:index, :destroy]
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_owner, :only => [:edit, :update]
  before_filter :require_owner_or_public_profile, :only => :show
  before_filter :set_default_domain, :only => :create

  respond_to :html, :js

  # index

  def create
    user = build_resource
    user.is_admin = true if User.count.zero?
    if user.save_without_session_maintenance
      user.deliver_activation_instructions!
      flash[:notice] = s_("Your account has been created. Please check your e-mail for your account activation instructions!")
      redirect_to "/"
    else
      render :action => :new
    end
  end

  def update
    @user = User.find(params[:id])
    return _remove_avatar if "true" == params[:remove_avatar]

    # manual update protected attributes
    if current_user.is_admin?
      @user.is_admin = params[:user].delete(:is_admin)
      @user.is_volunteer = params[:user].delete(:is_volunteer)
      @user.is_editor = params[:user].delete(:is_editor)
    end
    params[:user].trust(:email) if current_user.is_admin?
    update!
  end

  def destroy
    @user = User.enabled.find(params[:id])
    if @user.id == current_user.id
      flash[:error] = _("You cannot remove your own account")
      redirect_to users_path
      return
    end
    @user.update_attribute(:disabled_at, Time.now.utc)
    flash[:notice] = _("User disabled")
    redirect_to users_path
  end

  protected

  def public_profile?
    true == params[:public_profile]
  end
  helper_method :public_profile?

  def require_owner_or_public_profile
    return require_owner unless public_profile?

    return false unless require_user
    return true unless resource # let it fail
     # allow colunteers to see public profiles of admins and editors
    return true if current_user.is_volunteer? && resource.admin_or_editor?
    # allow editors and admins to see public profile of volunteers
    return true if resource.is_volunteer? && current_user.admin_or_editor?

    flash[:error] = _("Only registered activists allowed to access this page")
    redirect_to "/"
    return false
  end

  def require_owner
    return false unless require_user
    return true unless resource # let it fail
    return true if current_user.try(:is_admin?)
    return true if resource == current_user # owner

    flash[:error] = _("Only the owner can see this page")
    redirect_to "/"
    return false
  end

  def collection
    if params[:query].blank?
      @users ||= end_of_association_chain.send("true" == params[:all] ? :by_id : :enabled).active_first.paginate(:page => params[:page], :per_page => params[:per_page])
    else
      @users ||= User.send("true" == params[:all] ? :sp_all : :sp_enabled).sp_active_first.search(params[:query]).paginate(:page => params[:page], :per_page => params[:per_page])
    end
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

  def _remove_avatar
    @user.avatar = nil
    @user.save
    render(:update) do |page|
      page.redirect_to user_path(@user)
    end
  end
end
