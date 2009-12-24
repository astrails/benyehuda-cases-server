module PasswordsHelper
  def password_edit_title
    if logged_in?
      _("Change Password")
    elsif @user.active?
      _("Password Reset")
    else
      _("Activate Account")
    end
  end

  def password_edit_submit
    if logged_in?
      _("Change")
    elsif @user.active?
      _("Reset")
    else
      _("Activate")
    end
  end
end