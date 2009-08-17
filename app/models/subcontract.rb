class Subcontract < ActiveRecord::Base
  belongs_to :subcontractor
  has_many :line_items
  validates_presence_of :subcontractor_id
  validates_presence_of :start_date
  validates_presence_of :end_date
end
