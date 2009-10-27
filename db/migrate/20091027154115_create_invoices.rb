class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.integer :invoiceable_id
      t.string :invoiceable_type
      t.integer :appgen_cust_number
      t.string :invoice_number
      t.date :invoice_date
      t.decimal :invoice_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
