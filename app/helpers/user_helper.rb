module UserHelper

  ROLES = {
    "editor" => N_("user role|Editor"),
    "volunteer" => N_("user role|Volunteer"),
    "admin" => N_("user role|Admin")
  }

  def when_volunteer
    yield if current_user.is_volunteer?
  end

  def when_editor
    yield if current_user.is_editor?
  end

  def when_user_volunteer
    yield if @user.is_volunteer?
  end

  def when_user_editor
    yield if @user.is_editor?
  end

  def user_roles(roles)
    return "No roles defined" if roles.blank?
    roles.map{ |r| s_(ROLES[r])}.join(", ")
  end

  def when_editor_or_admin
    yield if current_user.admin_or_editor?
  end

  def person_link(user)
    return "" unless user
    return "me" if user.id == current_user.id
    link_to(h(user.name), profiles_path(user))
  end

  def activation_email_links(user)
    link_opts = 
    returning("") do |res|
      if user.activation_email_sent_at
        res << user.activation_email_sent_at.to_s
        res << " " << send_activation_link(user, s_("activation email|Resend")) unless user.activated_at
      else
        res << send_activation_link(user, s_("activation email|Send Activation Email"))
      end
    end
  end

protected
  def send_activation_link(user, text)
    link_to text, user_activation_instructions_path(user, :page => params[:page]), :method => :post, :confirm => (_("Send Activation Email to %{user}. Are you sure?") % {:user => "#{h(user.name)} <#{user.email}>"})
  end
end