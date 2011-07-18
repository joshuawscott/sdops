class AddListPriceIncreaseToSupportDeals < ActiveRecord::Migration
  def self.up
    add_column :support_deals, :list_price_increase, :decimal, :precision => 5, :scale => 3
  end

  def self.down
    remove_column :support_deals, :list_price_increase
  end
end
