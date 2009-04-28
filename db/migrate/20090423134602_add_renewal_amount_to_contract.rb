class AddRenewalAmountToContract < ActiveRecord::Migration
  def self.up
    add_column :contracts, :renewal_amount, :decimal, :precision => 20, :scale => 3
  end

  def self.down
    remove_column :contracts, :renewal_amount
  end
end
