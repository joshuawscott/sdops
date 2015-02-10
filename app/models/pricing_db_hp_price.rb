# Pricing for HP products from the _USUDDPprice_ table.  The inner workings of
# this class are somewhat different than the others, as HP does not release a
# monthly or annual support price listing.  Instead, the price is calculated
# based on calculating the difference between a 4-year and 3-year prepay
# contract.
#
# Because of the difference, this model relies heavily on
# PricingDbHpShortDescription (to find the description) and
# PricingDbHpSupportOption to match the part_number up with a prepay contract
# item and price in the USUDDPprice table.
# ===Schema (incomplete; most of the 33 fields are not used/needed)
#   date            date
#   product_number  string
#   price1          decimal(11,2)
#
# +price1+ is the actual list price of the item in the table, but since this is
# a product price list (not an ongoing support price list), we are not interested
# in that field directly.
class PricingDbHpPrice < PricingDb
  set_table_name "USUDDPprice".to_sym
  attr_accessor :type

  #
  def self.find_pn(part_number, type)
    @pricing_db_hp_price = self.find(:first, :conditions => ["product_number = ?", part_number]) || self.new
    @pricing_db_hp_price.type = type
    @pricing_db_hp_price
  end

  # Find a price for a hardware item, given a +part_number+.  If the
  # +part_number+ is not found, returns a new PricingDbHpPrice instance.
  def self.find_hw_pn(part_number)
    self.find_pn(part_number, 'hw')
  end

  # Find a price for a software item, given a +part_number+.  If the
  # +part_number+ is not found, returns a new PricingDbHpPrice instance.
  def self.find_sw_pn(part_number)
    self.find_pn(part_number, 'sw')
  end

  # Simulates a has_one relationship with PricingDbHpShortDescription.
  def pricing_db_hp_short_description
    PricingDbHpShortDescription.find(:first, :conditions => ['product_number = ?', product_number]) || PricingDbHpShortDescription.new
  end

  # Returns the description from the matching PricingDbHpShortDescription.  If
  # there is no matching description found, returns nil.
  def description
    pricing_db_hp_short_description.description
  end

  # Calculates the list price based on the difference between a 4-year contract
  # and a 3-year contract.  To work, there must be an HA104A3 or HA107A3 support
  # price in the table for our +@product_number+
  def list_price
    support_product_number = type == 'hw' ? 'HA104A' : 'HA107A'
    year1 = PricingDbHpPrice.option_price(:product_number => support_product_number, :year => 1, :option_number => option_number)
    year3 = PricingDbHpPrice.option_price(:product_number => support_product_number, :year => 3, :option_number => option_number)
    year4 = PricingDbHpPrice.option_price(:product_number => support_product_number, :year => 4, :option_number => option_number)
    @list_price = [(year4 - year3)/BigDecimal("12.0"), (year3 - year1)/BigDecimal("24.0")].max
  end

  # Simulates a has_one relationship to PricingDbHpSupportOption
  def pricing_db_hp_support_option
    PricingDbHpSupportOption.find(:first, :conditions => {:product_number => product_number}) || PricingDbHpSupportOption.new
  end

  # Returns +option_number+ from PricingDbHpSupportOption
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
