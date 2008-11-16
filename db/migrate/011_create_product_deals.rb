class CreateProductDeals < ActiveRecord::Migration
  def self.up
    create_table :product_deals do |t|
      t.string :job_number
      t.integer :sugar_opp_id
      t.string :account_id
      t.string :account_name
      t.string :invoice_number
      t.integer :revenue
      t.integer :cogs
      t.integer :freight
      t.string :status
      t.string :modified_by
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :product_deals
  end
end
