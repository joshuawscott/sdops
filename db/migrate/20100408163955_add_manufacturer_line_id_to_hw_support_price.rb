class AddManufacturerLineIdToHwSupportPrice < ActiveRecord::Migration
  def self.up
    add_column :hwdb, :manufacturer_line_id, :integer
  end

  def self.down
    remove_column :hwdb, :manufacturer_line_id
  end
end
