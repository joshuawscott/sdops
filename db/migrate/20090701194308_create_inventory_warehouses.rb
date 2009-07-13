class CreateInventoryWarehouses < ActiveRecord::Migration
  def self.up
    create_table :inventory_warehouses, :id => false do |t|
      t.string :code
      t.string :description
    end
    add_index :inventory_warehouses, :code, :unique => true
    add_column :inventory_items, :manufacturer, :string
  end

  def self.down
    drop_table :inventory_warehouses
    remove_column :inventory_items, :manufacturer
  end
end
