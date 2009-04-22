class CreateInventoryItems < ActiveRecord::Migration
  def self.up
    create_table :inventory_items, :id => false do |t|
      t.string :id, :null => false, :default => ""
      t.string :item_code
      t.string :description
      t.string :serial_number
      t.string :warehouse
      t.string :location
    end
    add_index :inventory_items, :id, :unique => true, :name => "tracking"
  end

  def self.down
    drop_table :inventory_items
  end
end
