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
        res << {:title => "Dashboard", :path => dashboard_path}
        if current_user.is_admin?
          res << {:title => "Users", :path => users_path}
          res << {:title => "Object Properties", :path => properties_path}
        end
        res << {:title => "Profile", :path => profile_path}
      end
    else
      false
    end
  end

  def boolean_property(value)
    value ? "true" : ""
  end
end
