class SwSupportPricesController < ApplicationController
  def index
    @productnumber = params[:productnumber]
    @description = params[:description]
    @items = SwSupportPrice.search(@productnumber, @description, Time.now.to_date)
  end
  def new
    @sw_support_price ||= SwSupportPrice.new
  end

  def create
    @sw_support_price = SwSupportPrice.new(params[:sw_support_price])
    if @sw_support_price.save
      flash[:notice] = "The price was saved successfully."
      redirect_to new_sw_support_price_path
    else
      flash[:notice] = "The price failed to save"
      render :action => "new"
    end
  end
end
