class HwSupportPricesController < ApplicationController
  def index
    @part_number = params[:part_number]
    @description = params[:description]
    @items = HwSupportPrice.search(@part_number, @description)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @hw_support_price ||= HwSupportPrice.new
    @hw_support_price.confirm_date ||= params[:confirm_date]
    @manufacturer_lines = ManufacturerLine.find(:all).sort_by {|x| x.manufacturer.name + x.name}
  end

  def create
    @hw_support_price = HwSupportPrice.new(params[:hw_support_price])
    if @hw_support_price.save
      flash[:notice] = "The price was saved successfully."
      redirect_to url_for(new_hw_support_price_path) + "?confirm_date=" + params[:hw_support_price][:confirm_date]
    else
      @manufacturer_lines = ManufacturerLine.find(:all).sort_by {|x| x.manufacturer.name + x.name}
      flash[:error] = "The price failed to save"
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
    @manufacturer_lines = ManufacturerLine.find(:all).sort_by {|x| x.manufacturer.name + x.name}
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

  def pull_pricing_helps
    part_number = params[:part_number]
    cisco = params[:ciscobox] == "true"
    @current_info = HwSupportPrice.current_list_price(part_number)
    @sun_info = PricingDbSunService.find_pn(part_number)
    @hp_info = PricingDbHpPrice.find_hw_pn(part_number)
    @emc_info = PricingDbEmc.find_pn(part_number)
    # Since we hit an external site, only hit it if explicitly requested
    if cisco
      @cisco_info = CiscoProduct.new(part_number)
    else
      @cisco_info = CiscoProduct.empty
    end
  end
end
