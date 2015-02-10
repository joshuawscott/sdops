require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'
# Fetches a price from a cisco reseller website, and converts it to our monthly
# pricing scheme.  Used by the pricing functions.
class CiscoProduct

  def initialize(pn)
    @part_number = pn

    #@price_xpath = "/html/body[@class='clsmargin']/table/tr[3]/td/table/tr/td/table/tr/td[2]/table/tr[3]/td/table/tr[5]/td[2]/table/tr[1]/td[4]/table[@class='tw']/tr[4]/td/table/tr/td/font/strong"
    @price_xpath = "//label[@id='calprice']/a"
    @description_url = "http://www.ithsc.com/ciscohardwaremaintenance/SMARTnet_calculator.php"
    #@description_xpath = "/html/body[@class='clsmargin']/table/tr[3]/td[1]/table/tr/td/table/tr/td[2]/table/tr[3]/td/table/tr[5]/td/table[@class='infoBox']/tr[@class='infoBoxContents']/td/table[2]/table/tr[4]/td[2]"
    @description_xpath = "//div[@id='qbcontent']/div[@class='listitem']/div[@class='desc']"
  end

  # This is a constructor method that prevents going out to the external site.
  def self.empty
    x = self.new("")
    x.description = ""
    x.full_price = 0.0
    x.base_price = 0.0
    x
  end

  def part_number
    @part_number
  end

  def part_number=(pn)
    @base_price = nil
    @full_price = nil
    @part_number = pn
  end

  def hw_price
    ((full_price - base_price) / 0.85) / 12.0
  end

  def sw_price
    (base_price / 0.85) / 12.0
  end

  def description
    return @description unless @description.nil?
    @description = Nokogiri::HTML(Net::HTTP.post_form(URI.parse(description_url), {'product' => URI.escape(part_number), 'submit1' => ''}).body).xpath(@description_xpath)
    if @description[0].nil?
      @description = ""
    else
      @description = @description[0].content
    end
  end

  def description=(description)
    @description = description
  end

  def base_price
    return @base_price unless @base_price.nil?
    @base_price = Nokogiri::HTML(open(base_url)).xpath(@price_xpath)
    puts "base price: #{@base_price}"
    if @base_price[0].nil?
      @base_price = 0.0
    else
      @base_price = @base_price[0].content.sub("$", "").to_f
    end
  end

  def base_price=(base_price)
    @base_price = base_price
  end

  def full_price
    return @full_price unless @full_price.nil?
    @full_price = Nokogiri::HTML(open(full_url)).xpath(@price_xpath)
    puts "full price: #{@full_price}"
    if @full_price[0].nil?
      @full_price = 0.0
    else
      @full_price = @full_price[0].content.sub("$", "").to_f
    end
  end

  def full_price=(full_price)
    @full_price = full_price
  end

  def base_url
    "http://www.ithsc.com/ciscohardwaremaintenance/ciscosmartnetquote.php?smartnetfor=" + URI.escape(part_number) + "&smb=1&smbsa=1&engineer=0&cover=8&response=0&length=1&currency=USD&countries_id=223"
  end

  def full_url
    "http://www.ithsc.com/ciscohardwaremaintenance/ciscosmartnetquote.php?smartnetfor=" + URI.escape(part_number) + "&smb=1&smbsa=1&engineer=1&cover=24&response=1&length=1&currency=USD&countries_id=223"
  end

  def description_url
    @description_url
  end


end

