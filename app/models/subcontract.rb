class Subcontract < ActiveRecord::Base
  belongs_to :subcontractor
  has_many :line_items
end
