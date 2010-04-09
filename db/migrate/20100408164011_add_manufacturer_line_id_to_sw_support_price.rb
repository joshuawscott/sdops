class AddManufacturerLineIdToSwSupportPrice < ActiveRecord::Migration
  def self.up
    add_column :swdb, :manufacturer_line_id, :integer
  end

  def self.down
    remove_column :swdb, :manufacturer_line_id
  end
end
