module ApplicationHelper
  def page_title(title=nil)
    if title.nil?
      @page_title ||= ""
    else
      @page_title = title
    end
  end

  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end

  def hebrew_layout?
    false
  end

  def tabs_for_current_user
    @tabs_for_current_user ||= if logged_in?
      returning([]) do |res|
        res << {:title => _("Dashboard"), :path => dashboard_path}
        if current_user.admin_or_editor?
          res << {:title => "Volunteer Requests", :path => volunteer_requests_path}
        end
        if current_user.is_admin?
          res << {:title => "Tasks Admin", :path => admin_tasks_path}
          res << {:title => "Users", :path => users_path}
          res << {:title => "Object Properties", :path => properties_path}
          res << {:title => "Global Preferences", :path => global_preferences_path}
        end
        res << {:title => _("Profile"), :path => profile_path}
      end
    else
      false
    end
  end

  def boolean_property(value)
    value ? "true" : ""
  end
end
