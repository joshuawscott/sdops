# Schema:
#   id            string
#   item_code     string
#   description   string
#   serial_number string
#   warehouse     string
#   location      string
class InventoryItem < ActiveRecord::Base
  # convenience method for the id field
  def tracking
    self.id
  end
end
