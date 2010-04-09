class Manufacturer < ActiveRecord::Base
  has_many :manufacturer_lines
end
