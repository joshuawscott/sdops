# Lines of products for Manufacturer's
# ===Schema
#   name            string
#   manufacturer_id integer
#   created_at      time
#   updated_at      time
#
class ManufacturerLine < ActiveRecord::Base
  belongs_to :manufacturer
  has_many :hw_support_prices
  has_many :sw_support_prices
end
