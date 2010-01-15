class ActivationInstructionsController < ApplicationController
  before_filter :require_admin

  def create
    user = User.find(params[:user_id])
    user.deliver_activation_instructions!
    flash[:notice] = _("Activation instructions sent to #{user.email}.")
    redirect_to users_path(:page => params[:page])
  end
end
