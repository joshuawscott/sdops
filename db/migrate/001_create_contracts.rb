class CreateContracts < ActiveRecord::Migration
  def self.up
    create_table :contracts do |t|
      t.string :sdc_ref
      t.string :description
      t.integer :sales_rep_id
      t.string :sales_office
      t.string :support_office
      t.string :account_id
      t.string :cust_po_num
      t.integer :payment_terms
      t.string :platform
      t.decimal :revenue
      t.decimal :annual_hw_rev
      t.decimal :annual_sw_rev
      t.decimal :annual_ce_rev
      t.decimal :annual_sa_rev
      t.decimal :annual_dr_rev
      t.date :start_date
      t.date :end_date
      t.date :multiyr_end
      t.string :expired
      t.integer :hw_support_level_id
      t.integer :sw_support_level_id
      t.string :updates
      t.integer :ce_days
      t.integer :sa_days
      t.decimal :discount_pref_hw
      t.decimal :discount_pref_sw
      t.decimal :discount_prepay
      t.decimal :discount_multiyear
      t.decimal :discount_ce_day
      t.decimal :discount_sa_day
      t.string :replacement_sdc_ref

      t.timestamps
    end
  end

  def self.down
    drop_table :contracts
  end
end
