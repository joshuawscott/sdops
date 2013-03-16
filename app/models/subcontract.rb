# A Subcontract is an agreement with a subcontractor that defines the SLA on
# certain LineItem objects.
# ===Schema
#   id          integer
#   subcontractor_id  integer
#   customer_number   string
#   sales_order_number  string
#   description       string
#   quote_number      string
#   sourcedirect_po_number  string
#   cost              decimal(20,2)
#   hw_response_time  string
#   sw_response_time  string
#   hw_repair_time    string
#   hw_coverage_days  string
#   sw_coverage_days  string
#   hw_coverage_hours string
#   sw_coverage_hours string
#   parts_provided    boolean
#   labor_provided    boolean
#   created_at        time
#   updated_at        time
#   start_date        date
#   end_date          date
class Subcontract < ActiveRecord::Base
  belongs_to :subcontractor
  has_many :line_items, :dependent => :nullify
  validates_presence_of :subcontractor_id
  validates_presence_of :start_date
  validates_presence_of :end_date
  has_many :comments, :as => :commentable
  named_scope :current, :conditions => ["end_date >= ?", Date.today]
  acts_as_audited
end
