require 'rubygems'
require 'nokogiri'
require 'open-uri'
class DellServiceTag
  attr_accessor :service_tag
  attr_accessor :model_number
  attr_accessor :dell_page
  attr_accessor :service_provider
  attr_accessor :support_level
  attr_accessor :start_date
  attr_accessor :end_date
  attr_accessor :days_left
  DELLURL1 = 'http://support.dell.com/support/topics/global.aspx/support/my_systems_info/details?c=us&cs=2684&l=en&s=biz&~ck=anavml&servicetag='
  DELLURL2 = '&~tab='
  def initialize(service_tag, tab_number)
    @service_tag = service_tag
    @tab_number = tab_number
    @dell_page = Nokogiri::HTML(open(dell_url))
    @model_number = @dell_page.css('td.gridCellAlt')[1].content
  end

  def dell_url
    DELLURL1 + @service_tag + DELLURL2 + @tab_number.to_s
  end

  def self.find_warranty(service_tag)
    new_dell_service_tag = self.new(service_tag, 1)
    raw_html = new_dell_service_tag.dell_page.css('td.contract_oddrow', 'td.contract_evenrow')
    # THERE HAS TO BE A BETTER WAY!!!

    days_left_array = []
    raw_html.each_with_index { |x, i| days_left_array << x.content.to_i if ((i+1) % 5) == 0 }

    curr_max = 0
    curr_max_index = 0
    correct_row = days_left_array.each_with_index do |x,i|
      if x > curr_max
        curr_max = x
        curr_max_index = i
      end
    end

    new_dell_service_tag.support_level = raw_html[0+curr_max_index].content
    new_dell_service_tag.service_provider = raw_html[1+curr_max_index].content
    new_dell_service_tag.start_date = raw_html[2+curr_max_index].content
    new_dell_service_tag.end_date = raw_html[3+curr_max_index].content
    new_dell_service_tag.days_left = raw_html[4+curr_max_index].content
    new_dell_service_tag
  end

  def self.find_configuration(service_tag)
    new_dell_service_tag = self.new(service_tag, 2)
    raw_html = new_dell_service_tag.dell_page.css('td.contract')
    new_dell_service_tag
  end

end
