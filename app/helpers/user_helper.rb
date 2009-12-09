module UserHelper

  # TODO: gettext
  ROLES = {
    "editor" => "Editor",
    "volunteer" => "Volunteer",
    "admin" => "Admin"
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
    roles.map{ |r| ROLES[r]}.join(", ")
  end

  def when_editor_or_admin
    yield if current_user.is_editor? || current_user.is_admin?
  end

  def person_link(user)
    return "" unless user
    return "me" if user.id == current_user.id
    link_to(h(user.name), profiles_path(user))
  end
end