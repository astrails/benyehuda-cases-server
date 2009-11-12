ActionController::Routing::Routes.draw do |map|
  map.resources :pages, :controller => 'pages', :only => [:show]

end
