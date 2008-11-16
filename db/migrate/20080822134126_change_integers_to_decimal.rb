class ChangeIntegersToDecimal < ActiveRecord::Migration
  def self.up
    change_column :contracts, :revenue, :decimal, :precision => 20, :scale => 3
    change_column :contracts, :annual_hw_rev, :decimal, :precision => 20, :scale => 3
    change_column :contracts, :annual_sw_rev, :decimal, :precision => 20, :scale => 3
    change_column :contracts, :annual_ce_rev, :decimal, :precision => 20, :scale => 3
    change_column :contracts, :annual_sa_rev, :decimal, :precision => 20, :scale => 3
    change_column :contracts, :annual_dr_rev, :decimal, :precision => 20, :scale => 3
    change_column :contracts, :discount_pref_hw, :decimal, :precision => 5, :scale => 3
    change_column :contracts, :discount_pref_sw, :decimal, :precision => 5, :scale => 3
    change_column :contracts, :discount_pref_srv, :decimal, :precision => 5, :scale => 3
    change_column :contracts, :discount_prepay, :decimal, :precision => 5, :scale => 3
    change_column :contracts, :discount_multiyear, :decimal, :precision => 5, :scale => 3
    change_column :contracts, :discount_ce_day, :decimal, :precision => 5, :scale => 3
    change_column :contracts, :discount_sa_day, :decimal, :precision => 5, :scale => 3
    
    change_column :line_items, :list_price, :decimal, :precision => 20, :scale => 3
    
    change_column :opportunities, :revenue, :decimal, :precision => 20, :scale => 3
    change_column :opportunities, :cogs, :decimal, :precision => 20, :scale => 3
    change_column :opportunities, :probability, :decimal, :precision => 5, :scale => 3
    
    change_column :product_deals, :revenue, :decimal, :precision => 20, :scale => 3
    change_column :product_deals, :cogs, :decimal, :precision => 20, :scale => 3
    change_column :product_deals, :freight, :decimal, :precision => 20, :scale => 3
    
  end

  def self.down
    change_column :contracts, :revenue, :integer
    change_column :contracts, :annual_hw_rev, :integer
    change_column :contracts, :annual_sw_rev, :integer
    change_column :contracts, :annual_ce_rev, :integer
    change_column :contracts, :annual_sa_rev, :integer
    change_column :contracts, :annual_dr_rev, :integer
    change_column :contracts, :discount_pref_hw, :integer
    change_column :contracts, :discount_pref_sw, :integer
    change_column :contracts, :discount_pref_srv, :integer
    change_column :contracts, :discount_prepay, :integer
    change_column :contracts, :discount_multiyear, :integer
    change_column :contracts, :discount_ce_day, :integer
    change_column :contracts, :discount_sa_day, :integer

    change_column :line_items, :list_price, :integer
    
    change_column :opportunities, :revenue, :integer
    change_column :opportunities, :cogs, :integer
    change_column :opportunities, :probability, :integer

    change_column :product_deals, :revenue, :integer
    change_column :product_deals, :cogs, :integer
    change_column :product_deals, :freight, :integer

  end
end
