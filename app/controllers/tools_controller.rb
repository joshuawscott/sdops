class ToolsController < ApplicationController
  def index
  end

  def hwpricing
    if (params[:productnumber].nil? && params[:description].nil?) || (params[:productnumber].strip == '' && params[:description].strip == '')
      @items = []
    else
      @items = SupportPriceHw.search(params[:productnumber], params[:description], Time.now)
      @productnumber ||= params[:productnumber]
      @description ||= params[:description]
    end
  end

  def swpricing
    if (params[:productnumber].nil? && params[:description].nil?) || (params[:productnumber].strip == '' && params[:description].strip == '')
      @items = []
    else
      @items = SupportPriceSw.search(params[:productnumber], params[:description], Time.now)
      @productnumber ||= params[:productnumber]
      @description ||= params[:description]
    end
  end

end
