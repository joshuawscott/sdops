class AppgenOrdersController < ApplicationController
  before_filter :authorized?
  def index
    @appgen_orders = AppgenOrder.find(:all)
  end
  def show
    @appgen_order = AppgenOrder.find(params[:id], :include => :appgen_order_lineitems)
  end

  protected
  def authorized?
    if logged_in? && current_user.role == ADMIN
       true
    else
       not_authorized
    end
  end

end
