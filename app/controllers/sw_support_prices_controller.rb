class SwSupportPricesController < ApplicationController
  def index
    @productnumber = params[:productnumber]
    @description = params[:description]
    @items = SwSupportPrice.search(@productnumber, @description, Time.now.to_date)
  end
end
