ActionController::Routing::Routes.draw do |map|
  map.root :controller => :pages, :action => :show, :id => :home

  map.resources :pages, :controller => 'pages', :only => [:show]

end
