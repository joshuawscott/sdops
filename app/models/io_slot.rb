# This is an I/O slot in a server, used for the _ioscan_ tool.
# ===Schema:
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
  validates_presence_of :server
  def sort_order
    ((chassis_number.nil? ? 0 : chassis_number) * 1000) + slot_number
  end
end
