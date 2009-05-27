class AddInvoicesTables < ActiveRecord::Migration
  def self.up
    create_table :appgen_orders, :id => false do |t|
      t.string  :id, :null => false, :default => ""
      t.integer :cust_code
      t.string  :cust_name
      t.string  :address2
      t.string  :address3
      t.string  :address4
      t.string  :cust_po_number
      t.date    :ship_date
      t.decimal :net_discount,  :precision => 7, :scale => 2
      t.decimal :sub_total,     :precision => 20, :scale => 5
      t.string  :sales_rep
    end
    add_index :appgen_orders, :id, :unique => true

    create_table :appgen_order_lineitems, :id => false do |t|
      t.string  :appgen_order_id, :null => false
      t.string  :part_number
      t.string  :description
      t.integer :quantity
      t.decimal :price,         :precision => 20, :scale => 5
      t.decimal :discount,      :precision => 7, :scale => 2
      t.string  :id, :null => false, :default => "" #tracking
    end
    add_index :appgen_order_lineitems, :id, :unique => true
    add_index :appgen_order_lineitems, :appgen_order_id
    
    create_table :appgen_order_serials, :id => false do |t|
      t.string  :id, :null => false, :default => "" #tracking
      t.string  :serial_number
    end
    add_index :appgen_order_serials, :id, :unique => true

    create_table :upfront_orders do |t|
      t.string  :appgen_order_id
      t.boolean :has_upfront_support, :default => true
      t.boolean :completed, :default => false
      t.integer :contract_id, :default => nil
    end
    add_index :upfront_orders, :appgen_order_id, :unique => true
    
  end

  def self.down
    drop_table :appgen_orders
    drop_table :appgen_order_lineitems
    drop_table :appgen_order_serials
    drop_table :upfront_orders
  end
end
