class CreateSubcontracts < ActiveRecord::Migration
  def self.up
    create_table :subcontracts do |t|
      t.integer :subcontractor_id
      t.string  :customer_number
      t.string  :site_number
      t.string  :sales_order_number
      t.string  :description
      t.string  :quote_number
      t.string  :sourcedirect_po_number
      t.decimal :cost, :precision => 20, :scale => 2
      t.string  :hw_response_time
      t.string  :sw_response_time
      t.string  :hw_repair_time
      t.string  :hw_coverage_days
      t.string  :sw_coverage_days
      t.string  :hw_coverage_hours
      t.string  :sw_coverage_hours
      t.boolean :parts_provided
      t.boolean :labor_provided
      
      t.timestamps
    end
    add_column :line_items, :subcontract_id,    :integer
    add_column :line_items, :subcontract_cost,  :decimal, :precision => 20, :scale => 2
  end

  def self.down
    drop_table :subcontracts
    remove_column :line_items, :subcontract_id
    remove_column :line_items, :subcontract_cost
  end
end
