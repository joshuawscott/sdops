class HwSupportPricesController < ApplicationController
  def index
    @part_number = params[:part_number]
    @description = params[:description]
    @items = HwSupportPrice.search(@part_number, @description, Time.now.to_date)
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
end
