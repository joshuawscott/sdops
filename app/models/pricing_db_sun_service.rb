class PricingDbSunService < PricingDb
  set_table_name :sun_svcs
  named_scope :all, :conditions => 'service_item_plan IN ("GOLD-7X24-STK-SVC", "GOLD-SYS-SVC", "PREM-SW-SVC")'

  def self.find_pn(part_number)
    @pricing_db_sun_service = self.all.find(:first, :conditions => ["mkt_part_number = ?", part_number]) || self.new
  end
  def pricing_db_sun_description
    PricingDbSunDescription.find(:first, :conditions => ["mkt_part_number = ?", mkt_part_number]) || PricingDbSunDescription.new
  end

  def description
    pricing_db_sun_description.short_description
  end

  def list_price
    return BigDecimal("0.6") * oow_price if service_item_plan == "GOLD-SYS-SVC"
    oow_price
  end

  def part_number
    mkt_part_number
  end
end
