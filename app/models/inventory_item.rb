# Schema:
#   id            string
#   item_code     string
#   description   string
#   serial_number string
#   warehouse     string
#   location      string
#   manufactuer   string
class InventoryItem < ActiveRecord::Base
  #custom association for InventoryWarehouse...
  def inventory_warehouse
    InventoryWarehouse.find_by_sql("select * from inventory_warehouses where code = '#{warehouse}'")[0]
  end
  # convenience method for the id field
  def tracking
    self.id
  end
end
