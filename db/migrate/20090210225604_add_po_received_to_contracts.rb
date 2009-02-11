class AddPoReceivedToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :po_received, :date
  end

  def self.down
    remove_column :contracts, :po_received
  end
end
