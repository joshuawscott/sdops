class AddColumnsToProductDeals < ActiveRecord::Migration
  def self.up
    add_column :product_deals, :sales_office, :string
    add_column :product_deals, :sales_office_name, :string
    add_column :product_deals, :customer_po, :string
    add_column :product_deals, :customer_po_date, :date
    add_column :product_deals, :description, :string
    rename_column :product_deals, :freight, :other_costs
  end

  def self.down
    remove_column :product_deals, :sales_office
    remove_column :product_deals, :sales_office_name
    remove_column :product_deals, :customer_po
    remove_column :product_deals, :customer_po_date
    remove_column :product_deals, :description
    rename_column :product_deals, :other_costs, :freight
  end
end
