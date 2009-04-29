#Schema:
#   id            integer
#   server_id     integer
#   slot_number   integer
#   path          string
#   created_at    datetime
#   updated_at    datetime
#   description   string
class IoSlot < ActiveRecord::Base
  belongs_to :server
  validates_uniqueness_of :path, :scope => [:server_id]

  def sort_order
    (chassis_number.nil? ? 0 : chassis_number) * 1000 + slot_number
  end
end
