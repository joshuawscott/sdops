# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :set_default_format
  before_filter :login_required
  audit Contract, Dropdown, IoSlot, LineItem, Server, SupportPriceHw, SupportPriceSw, SwlistBlacklist, SwlistWhitelist, Swproduct, UpfrontOrder, User
  #To overcome IE7 Accept-Header Issue
  def set_default_format
    params[:format] ||= 'html'
  end
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '3cfd32d4bfdff426cc56d6c51bf3dfb8'
  
  #Hide passwords in logs
  filter_parameter_logging "password"
end

