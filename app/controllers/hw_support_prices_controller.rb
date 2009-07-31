class HwSupportPricesController < ApplicationController
  def index
    @part_number = params[:part_number]
    @description = params[:description]
    @items = HwSupportPrice.search(@part_number, @description)
  end

  def new
    @hw_support_price ||= HwSupportPrice.new
  end

  def create
    @hw_support_price = HwSupportPrice.new(params[:hw_support_price])
    if @hw_support_price.save
      flash[:notice] = "The price was saved successfully."
      redirect_to new_hw_support_price_path
    else
      flash[:notice] = "The price failed to save"
      render :action => "new"
    end
  end

  def destroy
    @hw_support_price = HwSupportPrice.find(params[:id])
    @hw_support_price.destroy
    respond_to do |format|
      format.html {redirect_to(hw_support_prices_url)}
    end
  end

  def edit
    @hw_support_price = HwSupportPrice.find(params[:id])
  end

  def update
    @hw_support_price = HwSupportPrice.find(params[:id])
    if @hw_support_price.update_attributes(params[:hw_support_price])
      flash[:notice] = "Price successfully updated"
      redirect_to hw_support_prices_path
    else
      flash[:notice] = "FAILURE!"
      render :action => "edit"
    end
  end
end
