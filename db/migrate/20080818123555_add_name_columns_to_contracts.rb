class AddNameColumnsToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :sales_office_name, :string
    add_column :contracts, :support_office_name, :string
  end

  def self.down
    remove_column :contracts, :sales_office_name
    remove_column :contracts, :support_office_name
  end
end
