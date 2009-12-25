module TabsHelper
  TABS = [
    {:name => :dashboard, :title => N_("Dashboard"), :path => "/dashboard"},
    {:name => :volunteer_requests, :title => N_("Volunteer Requests"), :path => "/volunteer_requests", :if => :admin_or_editor?},
    {:name => :tasks_admin, :title => N_("Tasks Admin"), :path => "/admin/tasks", :if => :is_admin?}, 
    {:name => :users, :title => N_("Users"), :path => "/users", :if => :is_admin?}, 
    {:name => :object_prefs, :title => N_("Object Properties"), :path => "/properties", :if => :is_admin?}, 
    {:name => :global_prefs, :title => N_("Global Preferences"), :path => "/global_preferences", :if => :is_admin?},
    {:name => :translations, :title => N_("Translations"), :path => "/translation_keys", :if => :is_admin?},
    {:name => :profile, :title => N_("Profile"), :path => "/profile"}
  ]

  def tabs_by_name
    @tabs_by_name ||= TABS.inject({}) do |res, tab|
      res[tab[:name]] = tab
      res
    end
  end

  def set_tab(name)
    name = name.to_sym
    @current_tab = name
    @page_title ||= tabs_by_name[name]
  end
end