Rails.application.routes.draw do
  match "/restart" => "restart#restart", :via => :post
end