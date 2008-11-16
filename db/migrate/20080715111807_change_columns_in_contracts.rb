class ChangeColumnsInContracts < ActiveRecord::Migration
  def self.up
    rename_column :contracts, :office_id, :sales_office
    rename_column :contracts, :primary_office, :support_office
    rename_column :contracts, :hp3000, :platform
  end

  def self.down
    rename_column :contracts, :sales_office, :office_id
    rename_column :contracts, :support_office, :primary_office
    rename_column :contracts, :platform, :hp3000
  end
end
