class AddDatesToSubcontract < ActiveRecord::Migration
  def self.up
    add_column :subcontracts, :start_date,  :date
    add_column :subcontracts, :end_date,    :date
  end

  def self.down
    remove_column :subcontracts, :start_date
    remove_column :subcontracts, :end_date
  end
end
