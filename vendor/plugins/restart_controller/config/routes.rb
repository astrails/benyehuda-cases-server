ActionController::Routing::Routes.draw do |map|
  map.restart "/restart", :controller => "restart", :action => "restart", :conditions => { :method => :post }
end