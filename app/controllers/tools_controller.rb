class ToolsController < ApplicationController
  def index
  end

  def hwpricing
    if (params[:productnumber].nil? && params[:description].nil?) || (params[:productnumber].strip == '' && params[:description].strip == '')
      @items = []
    else
      @items = HwSupportPrice.search(params[:productnumber], params[:description])
      @productnumber ||= params[:productnumber]
      @description ||= params[:description]
    end
  end

  def swpricing
    if (params[:productnumber].nil? && params[:description].nil?) || (params[:productnumber].strip == '' && params[:description].strip == '')
      @items = []
    else
      @items = SwSupportPrice.search(params[:productnumber], params[:description])
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

  def hp_warranty
    @warranty_info = []
    if params[:serial_numbers]
      sn_list = params[:serial_numbers].strip.split("\r\n").reject {|x| x.nil? || x.strip.blank?}
      @warranty_info = sn_list.map {|serial_number| HpWarranty.new(serial_number)}
#      if params[:pn] == '' || params[:pn].nil?
#        part_number = nil
#      else
#        part_number = params[:pn]
#      end
#      serial_number = params[:sn]
#      @warranty_info = HpWarranty.new(part_number,serial_number)
    end
  end

end
