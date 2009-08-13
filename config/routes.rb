ActionController::Routing::Routes.draw do |map|
  map.resources :subcontracts, :collection => {:add_line_items => :post}

  map.resources :subcontractors

  map.resources :hw_support_prices, :collection => {:pull_pricing_helps => :post}
  map.resources :sw_support_prices, :collection => {:pull_pricing_helps => :post}

  map.resources :roles

  map.resources :appgen_orders
  map.resources :appgen_order_lineitems
  map.resources :appgen_serials
  map.resources :upfront_orders, :collection => {:update_from_appgen => :put}, :member => {:save_import => :put, :review_import => :get}
  
  map.resources :swproducts

  map.resources :swlist_whitelists, :has_many => :swproducts

  map.resources :swlist_blacklists

  map.resources :io_slots

  map.resources :servers

  map.resources :swlists
  
  map.resources :ioscans
  
  map.resources :servers, :has_many => :io_slots

  map.resources :inventory_items

  map.resources :line_items, :collection => { :mass_update => :put, :form_pull_pn_data => :post }

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

  #map.resources  :admin, :controller => 'admin'

  #Non-Restful Routes
  map.lineitems '/contracts/:id/lineitems.xls', :controller => 'contracts', :action => 'lineitems', :format => 'xls'
  map.newbusiness '/reports/newbusiness.xls', :controller => 'reports', :action => 'newbusiness', :format => 'xls'

  map.refresh '/refresh', :controller => 'users', :action => 'refresh'

  map.reports '/reports', :controller => 'reports', :action => 'index'
  map.xlsreports '/reports/:action.:format', :controller => 'reports'

  map.tools '/tools/:action', :controller => 'tools'
  map.admin '/admin', :controller => 'admin', :action => 'index'

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.home '', :controller => "contracts"

  # See how all your routes lay out with "rake routes"
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
