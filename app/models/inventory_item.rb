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

  def office
    wh_city = inventory_warehouse.description.split(" ")
    @office = case wh_city[0]
      when "Philly" then "Philadelphia"
      when "Rentals" then "NONE"
      when "Onsite" then "NONE"
      when "Los" then wh_city[0] + " " + wh_city[1]
      else wh_city[0]
    end
    @office
  end

  def self.warehouse_code_for(office)
    @warehouse_name =
    case office
    when "Philadelphia" then "Philly Spares"
    when "Los Angeles" then "Los Angeles CA"
    when "Dayton" then "Dayton Ohio"
    else office + " Spares"
    end
    InventoryWarehouse.find(:first, :conditions => "description LIKE '#{@warehouse_name}%'").code
  end
end
