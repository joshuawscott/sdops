class AddColumnToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :discount_pref_srv, :integer
  end

  def self.down
    remove_column :contracts, :discount_pref_srv
  end
end
