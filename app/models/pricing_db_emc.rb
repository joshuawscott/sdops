class PricingDbEmc < PricingDb
  set_table_name :emc_support

  def list_price
    monthly
  end

  def self.find_pn(part_number)
    @pricing_db_emc = self.find(:first, :conditions => ["model_number = ?", part_number], :order => "effective_date DESC") || self.new
  end

end
