# This class contains the descriptions for the HP products.
# ===Schema (abbreviated)
#   product_number  string
#   description     string
#
class PricingDbHpShortDescription < PricingDb
  set_table_name "99ShortDescr".to_sym
end
