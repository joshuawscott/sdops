class SwSupportPricesController < ApplicationController
  def index
    @productnumber = params[:productnumber]
    @description = params[:description]
    @items = SwSupportPrice.search(@productnumber, @description)
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

  def destroy
    @sw_support_price = SwSupportPrice.find(params[:id])
    @sw_support_price.destroy
    respond_to do |format|
      format.html {redirect_to(sw_support_prices_url)}
    end
  end

  def edit
    @sw_support_price = SwSupportPrice.find(params[:id])
  end

  def update
    @sw_support_price = SwSupportPrice.find(params[:id])
    if @sw_support_price.update_attributes(params[:sw_support_price])
      flash[:notice] = "Price successfully updated"
      redirect_to sw_support_prices_path
    else
      flash[:notice] = "FAILURE!"
      render :action => "edit"
    end
  end

end
