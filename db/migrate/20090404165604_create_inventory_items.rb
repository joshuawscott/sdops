class CreateInventoryItems < ActiveRecord::Migration
  def self.up
    create_table :inventory_items do |t|
      t.string :tracking
      t.string :item_code
      t.string :description
      t.string :warehouse
      t.string :location
      t.string :serial_number
      t.string :commited
      t.decimal :cost

      t.timestamps
    end
  end

  def self.down
    drop_table :inventory_items
  end
end
