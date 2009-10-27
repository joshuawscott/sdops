class CreateInvoicePayments < ActiveRecord::Migration
  def self.up
    create_table :invoice_payments do |t|
      t.integer :invoice_id
      t.integer :payment_id
    end
  end

  def self.down
    drop_table :invoice_payments
  end
end
