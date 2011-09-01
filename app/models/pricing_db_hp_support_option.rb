# This class allows PricingDbHpPrice to match an upfront support product with
# an item of hardware or software.
# ===Schema
#   product_number  string
#   option_number   string
#
class PricingDbHpSupportOption < PricingDb
  set_table_name :support
end
