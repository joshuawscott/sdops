ActionController::Routing::Routes.draw do |map|
  map.resources :opportunities

  map.resources :product_deals

  map.resources :sugar_opps
  
  map.resources :sugar_accts
  
  map.resources :locations

  map.resources :users
  
  map.resources :sessions

  map.resources :dropdowns

  map.resources :comments

  map.resources :contracts, :has_many => :line_items
  
  
  map.resources :import, :controller => 'import'
  
  map.resources  :admin, :controller => 'admin'
  
  #Non-Restful Routes
  map.refresh '/refresh', :controller => 'users', :action => 'refresh'

  map.reports '/reports', :controller => 'reports', :action => 'index'

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.home '', :controller => "contracts"
    
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
