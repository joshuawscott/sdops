class AddRenewalSentToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :renewal_sent, :date
  end

  def self.down
    remove_column :contracts, :renewal_sent
  end
end
