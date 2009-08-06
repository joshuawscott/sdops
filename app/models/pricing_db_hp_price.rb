class PricingDbHpPrice < PricingDb
  set_table_name "USUDDPprice".to_sym
  attr_accessor :type

  def self.find_pn(part_number,type)
    @pricing_db_hp_price = self.find(:first, :conditions => ["product_number = ?", part_number]) || self.new
    @pricing_db_hp_price.type = type
    @pricing_db_hp_price
  end

  def self.find_hw_pn(part_number)
    self.find_pn(part_number, 'hw')
  end

  def self.find_sw_pn(part_number)
    self.find_pn(part_number, 'sw')
  end

  def pricing_db_hp_short_description
    PricingDbHpShortDescription.find(:first, :conditions => ['product_number = ?', product_number]) || PricingDbHpShortDescription.new
  end

  def description
    pricing_db_hp_short_description.description
  end

  def list_price
    support_product_number = type == 'hw' ? 'HA104A' : 'HA107A'
    year1 = PricingDbHpPrice.option_price(:product_number => support_product_number, :year => 1, :option_number => option_number)
    year3 = PricingDbHpPrice.option_price(:product_number => support_product_number, :year => 3, :option_number => option_number)
    year4 = PricingDbHpPrice.option_price(:product_number => support_product_number, :year => 4, :option_number => option_number)
    @list_price = [(year4 - year3)/BigDecimal("12.0"), (year3 - year1)/BigDecimal("24.0")].max
  end

  def pricing_db_hp_support_option
    PricingDbHpSupportOption.find(:first, :conditions => {:product_number => product_number}) || PricingDbHpSupportOption.new
  end

  def option_number
    pricing_db_hp_support_option.option_number
  end

  # returns the support cost for an option number.  options:
  #   :product_number -> the product number prefix (HA104A or HA107A)
  #   :year => the length of the term
  #   :option_number -> the option number that is being searched for.
  # returns 0 if nothing is found.
  def self.option_price(options={})
    sup_pn = options.delete(:product_number)
    year = options.delete(:year)
    opt_num = options.delete(:option_number)
    option_price_object = self.find(:first, :select => :price1, :conditions => " product_number = '#{sup_pn}#{year}     #{opt_num}'") || self.new(:price1 => BigDecimal("0.0"))
    @option_price = option_price_object.price1
  end

end
