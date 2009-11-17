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
      true
    else
      false
    end
  end
end
