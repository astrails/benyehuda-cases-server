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
    return _("me") if user.id == current_user.id
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

  def email_notifications(user)
    returning([]) do |res|
      res << _("When a comment added to my task") if user.notify_on_comments?
      res << _("When my task status changed") if user.notify_on_status?
      res << s_("notifications|None") if res.blank?
    end.join(", ")
  end

  def avatar_for(user, style = :thumb)
    user.avatar? ? user.avatar.url(style) : user.gravatar_url(:size => User.style_to_size(style))
  end

  def user_css_class(user)
    if user.disabled_at
      "disabled-user"
    else
      ""
    end
  end

protected
  def send_activation_link(user, text)
    link_to text, user_activation_instructions_path(user, :page => params[:page]), :method => :post, :confirm => (_("Send Activation Email to %{user}. Are you sure?") % {:user => "#{h(user.name)} <#{user.email}>"})
  end
end