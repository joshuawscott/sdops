# Manufacturers for SupportPricingDb items.
# ===Schema
#   name        string
#   created_at  time
#   updated_at  time
#
class Manufacturer < ActiveRecord::Base
  has_many :manufacturer_lines
end
