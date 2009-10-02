class AddNewBusinessDollarsToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :new_business_dollars, :decimal
  end

  def self.down
    remove_column :contracts, :new_business_dollars
  end
end
