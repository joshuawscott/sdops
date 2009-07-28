class ToolsController < ApplicationController
  def index
  end

  def hwpricing
    if (params[:productnumber].nil? && params[:description].nil?) || (params[:productnumber].strip == '' && params[:description].strip == '')
      @items = []
    else
      @items = HwSupportPrice.search(params[:productnumber], params[:description], Time.now)
      @productnumber ||= params[:productnumber]
      @description ||= params[:description]
    end
  end

  def swpricing
    if (params[:productnumber].nil? && params[:description].nil?) || (params[:productnumber].strip == '' && params[:description].strip == '')
      @items = []
    else
      @items = SwSupportPrice.search(params[:productnumber], params[:description], Time.now)
      @productnumber ||= params[:productnumber]
      @description ||= params[:description]
    end
  end

  def dell_service_tag
    @warranty_info = []
    if params[:service_tags]
      st_list = params[:service_tags].strip.split("\r\n").reject  {|x| x.nil? || x.strip.blank?}
      @warranty_info = st_list.map { |service_tag| DellServiceTag.find_warranty(service_tag.strip)}
    end
  end

  def dell_configuration
    if params[:service_tag]
      @service_tag = params[:service_tag].strip if params
      @configuration = DellServiceTag.find_configuration(@service_tag)
    end
  end

end
