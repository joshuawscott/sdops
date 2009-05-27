# Schema
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
end
