module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end

  def hebrew_layout?
    "he" == current_locale
  end

  def current_locale
    'he' # XXX
  end

  def render_tabs
    return unless logged_in?
    haml_tag(:ul, :class => "tabs") do
      TabsHelper::TABS.each do |tab|
        next if tab[:if] && !current_user.send(tab[:if])

        opts = {}
        opts[:class] = "selected" if @current_tab == tab[:name]

        haml_tag :li do
          haml_concat link_to(s_(tab[:title]), tab[:path], opts)
        end
      end
    end
  end

  def site_notices
    SiteNotice.active.each do |sn|
      haml_tag(:div, sn.html.html_safe, :class => "site-notice")
    end
  end

  def boolean_property(value)
    value ? "&#8730;" : ""
  end
end
