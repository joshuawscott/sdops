# ==DEPRECATED
# This was a table populated by a cronjob that pulled data from the
# Appgen accounting system.  We no longer use this, and it has been replaced by
# the Fishbowl and Fishbowl* classes.
# ===Schema
#   id             string
#   cust_code      integer
#   cust_name      string
#   address2       string
#   address3       string
#   address4       string
#   cust_po_number string
#   ship_date      date
#   net_discount   decimal
#   sub_total      decimal
#   sales_rep      string

class AppgenOrder < ActiveRecord::Base
  has_many :appgen_order_lineitems
  has_many :appgen_order_serials, :through => :appgen_order_lineitems
  has_one :upfront_order

  #consistent interface between this and fishbowl_so
  def line_items
    appgen_order_lineitems
  end
  def num
    id
  end
  def salesman
    ""
  end
end
