class AddSoAndPoToContract < ActiveRecord::Migration
  def self.up
    add_column :contracts, :so_number, :string
    add_column :contracts, :po_number, :string
  end

  def self.down
    remove_column :contracts, :po_number
    remove_column :contracts, :so_number
  end
end
