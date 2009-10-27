class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :appgen_cust_number
      t.string :payment_number
      t.date :payment_date
      t.decimal :payment_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
