class ToolsController < ApplicationController
  before_filter :login_required
  before_filter :set_current_tab
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

  private
  def set_current_tab
    @current_tab = self.action_name
  end

end
