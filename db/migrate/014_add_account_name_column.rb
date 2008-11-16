class AddAccountNameColumn < ActiveRecord::Migration
  def self.up
    add_column :contracts, :account_name, :string
  end

  def self.down
    remove_column :contracts, :account_name
  end
end
