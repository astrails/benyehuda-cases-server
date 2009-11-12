module PasswordsHelper
  def password_edit_title
    if logged_in?
      "Change Password"
    elsif @user.active?
      "Password Reset"
    else
      "Activate Account"
    end
  end

  def password_edit_submit
    if logged_in?
      "Change"
    elsif @user.active?
      "Reset"
    else
      "Activate"
    end
  end
end