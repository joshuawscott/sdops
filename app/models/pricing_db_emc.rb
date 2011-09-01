# Get an EMC price and description from the emc_support table
# ===Schema
#   model_number    string
#   description     string
#   annual          decimal(9,2)
#   monthly         decimal(9,2)
#   source          string
#   effective_date  date
class PricingDbEmc < PricingDb
  set_table_name :emc_support

  # alias for +monthly+
  def list_price
    monthly
  end

  # Finds a PricingDbEmc instance given a +part_number+.
  # If the +part_number+ is not found, Returns a new PricingDbEmc instance.
  def self.find_pn(part_number)
    @pricing_db_emc = self.find(:first, :conditions => ["model_number = ?", part_number], :order => "effective_date DESC") || self.new
  end

end
