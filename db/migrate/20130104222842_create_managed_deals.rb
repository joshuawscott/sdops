class CreateManagedServiceTables < ActiveRecord::Migration
  def self.up
    create_table :managed_deals do |t|
      t.string :account_id
      t.string :end_user_id
      t.string :sales_office_id
      t.string :sales_rep_id
      t.string :customer_po_number
      t.string :payment_terms
      t.string :initial_annual_revenue
      t.string :description
      t.date :start_date
      t.date :end_date
      t.date :renewal_created
      t.timestamps
    end
    create_table :managed_deal_elements do |t|
      t.string :type
      t.string :hostname
      t.string :ip_address
      t.string :serial_number
      t.string :footprints_id #link to SQL Server
      t.timestamps
    end
    create_table :managed_deal_items do |t|
      t.integer :managed_deal_element_id
      t.integer :managed_deal_id
      t.integer :managed_service_id
      t.date :start_date
      t.date :end_date
      t.decimal :monthly_price
      t.string :description
      t.boolean :remediation
      t.timestamps
    end
    create_table :managed_services do |t|
      t.string :name
      t.string :category
      t.string :version
      t.text :description
      t.decimal :monthly_cost
      t.timestamps
    end
  end

  def self.down
    drop_table :managed_deals
    drop_table :managed_deal_elements
    drop_table :managed_deal_items
    drop_table :managed_services
  end
end
