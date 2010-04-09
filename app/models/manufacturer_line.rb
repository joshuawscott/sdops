class ManufacturerLine < ActiveRecord::Base
  belongs_to :manufacturer
  has_many :hw_support_prices
  has_many :sw_support_prices
end
