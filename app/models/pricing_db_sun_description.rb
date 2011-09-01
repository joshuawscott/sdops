# Contains descriptions for Sun/Oracle products.  The prices in this table are
# for hardware and software products, not support.  Only used for descriptions.
# ===Schema
#   price_list        string
#   mkt_part_number   string
#   short_description string
#   product_family_grp_cd string
#   platform          string
#   warranty_cat      string
#   warranty_term     string
#   solaris_cat       string
#   serialization     string
#   lead_time         decimal(15,0)
#   pricing_discount_cat  string
#   country           string
#   currency          string
#   price             string
#   uom               string
#   price_start_date  date
#   price_end_date    date
#   eol_announce_date date
#
class PricingDbSunDescription < PricingDb
  set_table_name :sun_hwsw
end

