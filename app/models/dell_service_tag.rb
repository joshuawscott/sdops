require 'rubygems'
require 'nokogiri'
require 'open-uri'
# Scrapes Dell's website for information on a particular Dell "Service Tag"
# (similar to a serial number)
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


  # Takes a String (service_tag) and a Fixnum(tab_number) and returns a new
  # instance of DellServiceTag
  def initialize(service_tag, tab_number)#:nodoc:
    @service_tag = service_tag
    @tab_number = tab_number
    @dell_page = Nokogiri::HTML(open(dell_url))
    @line_items = []
    @model_number = @dell_page.css('td.gridCellAlt')[1].content if @dell_page
  end

  # returns a URL formed by inserting the service tag and tab number
  def dell_url
    DELLURL1 + @service_tag + DELLURL2 + @tab_number.to_s
  end

  # Returns a new DellServiceTag with warranty information set.
  def self.find_warranty(service_tag)
    new_dell_service_tag = self.new(service_tag, 1)
    raw_html = new_dell_service_tag.dell_page.css('td.contract_oddrow', 'td.contract_evenrow')

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

  # Returns a new DelLServiceTag with Configuration information set
  # _Please take a look at the source if this breaks for help_
  def self.find_configuration(service_tag)
    new_dell_service_tag = self.new(service_tag, 2)


    # I view this as a fragile way to scrape... any changes by Dell can (and
    # sometimes does) breaks it. In case there's a problem with this model in
    # the future, the alternate code may still work, but it may be a matter of
    # simply looking at the Dell HTML source to re-point at the right area.

    raw_html = new_dell_service_tag.dell_page.xpath("/html[1]/body/table/tr/td/div[1]/table/tr/td/div/table[2]/tr/td[2]/table/tr[4]/td/div[2]/table/tr[4]/td/table/tr/td")[4..-3]
    # If I need to debug:
    #puts "------------------------------------------------"
    #puts raw_html
    #puts "------------------------------------------------"
    raw_html.each_slice(3) do |line|
      new_dell_service_tag.add_line_item(DellServiceTagLineItem.new(line[0].content,line[1].content,line[2].content))
    end

    # Alternate code, this one uses CSS classes to find the data.  The problem
    # with this method is that it grabs all the odd numbered lines, then the
    # even numbered, so they are not arranged in the same order as on the Dell
    # site.
    # ==Code
    #   raw_html1 = new_dell_service_tag.dell_page.css('td.gridCell')[4..-3]
    #   raw_html2 = new_dell_service_tag.dell_page.css('td.gridCellAlt')[4..-1]
    #   raw_html1.each_slice(3) do |line|
    #     new_dell_service_tag.add_line_item(DellServiceTagLineItem.new(line[0].content,line[1].content,line[2].content))
    #   end
    #   raw_html2.each_slice(3) do |line|
    #     new_dell_service_tag.add_line_item(DellServiceTagLineItem.new(line[0].content,line[1].content,line[2].content))
    #   end

    new_dell_service_tag
  end

  # line_items is an Array of DellServiceTagLineItem
  def line_items
    @line_items
  end

  def add_line_item(line_item)
    @line_items << line_item
  end

end

# This class is to provide convenience methods for accessing data about each
# line item in a DellServiceTag
class DellServiceTagLineItem
  attr_accessor :quantity, :part_number, :description
  def initialize(qty,pn,desc)
    @quantity = qty
    @part_number = pn
    @description = desc
  end
end
