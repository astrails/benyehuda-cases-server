ActionController::Routing::Routes.draw do |map|
  map.activate '/activate/:id', :controller => 'passwords', :action => 'edit'
  map.password_update '/password', :controller => 'passwords', :action => 'update', :conditions => { :method => :put }
  map.password_edit '/password', :controller => 'passwords', :action => 'edit', :conditions => { :method => :get }
  map.resources :passwords, :only => [:new, :create, :edit, :update]
  map.login "/login", :controller => "user_session", :action => "new"
  map.resource :user_session, :controller => "user_session"
  map.signup "/signup", :controller => "users", :action => "new"
  map.resources :users
  map.resource :profile, :controller => "users"
  map.root :controller => :pages, :action => :show, :id => :home

  map.resources :pages, :controller => 'pages', :only => [:show]
  map.resources :properties
  map.resource :dashboard
  map.resources :volunteer_requests
  map.namespace :admin do |admin|
    admin.resources :tasks
  end
end
