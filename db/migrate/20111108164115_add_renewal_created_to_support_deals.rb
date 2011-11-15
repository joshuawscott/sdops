class AddRenewalCreatedToSupportDeals < ActiveRecord::Migration
  def self.up
    add_column :support_deals, :renewal_created, :date
  end

  def self.down
    remove_column :support_deals, :renewal_created
  end
end
