class CreateInventoryItems < ActiveRecord::Migration
  def self.up
    create_table :inventory_items, :id => false, :primary_key => :tracking do |t|
      t.string :tracking
      t.string :item_code
      t.string :description
      t.string :serial_number
      t.string :warehouse
      t.string :location
    end
  end

  def self.down
    drop_table :inventory_items
  end
end
