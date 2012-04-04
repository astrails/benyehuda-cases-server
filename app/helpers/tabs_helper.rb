module TabsHelper
  TABS = [
    {:name => :translations, :title => N_("Translations"), :path => "/translation_keys", :if => :is_admin?},
    {:name => :global_prefs, :title => N_("Global Preferences"), :path => "/global_preferences", :if => :is_admin?},
    {:name => :site_notices, :title => N_("Site Notice"), :path => "/site_notices", :if => :is_admin?},
    {:name => :object_prefs, :title => N_("Object Properties"), :path => "/properties", :if => :is_admin?},
    {:name => :profile, :title => N_("Profile"), :path => "/profile"},
    {:name => :volunteer_requests, :title => N_("Volunteer Requests"), :path => "/volunteer_requests", :if => :admin_or_editor?},
    {:name => :volunteer_kinds, :title => N_("Volunteer Kinds"), :path => "/admin/volunteer_kinds", :if => :is_admin?},
    {:name => :users, :title => N_("Users"), :path => "/users", :if => :is_admin?}, 
    {:name => :tasks_admin, :title => N_("Tasks Admin"), :path => "/admin/tasks", :if => :is_admin?},
    {:name => :dashboard, :title => N_("Dashboard"), :path => "/dashboard"},
  ]

  def tabs_by_name
    @tabs_by_name ||= TABS.inject({}) do |res, tab|
      res[tab[:name]] = tab
      res
    end
  end

  def set_tab(name, page_title = nil)
    name = name.to_sym
    @current_tab = name
    case page_title
    when String
      @page_title = page_title
      render_page_title
    when NilClass
      @page_title ||= s_(tabs_by_name[name][:title])
      render_page_title
    end
  end

  def render_page_title
    haml_tag(:h3, @page_title)
  end
end