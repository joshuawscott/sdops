class AppgenOrdersController < ApplicationController
  def index
    @appgen_orders = AppgenOrder.find(:all)
  end
  def show
    @appgen_order = AppgenOrder.find(params[:id], :include => :appgen_order_lineitems)
  end
end
