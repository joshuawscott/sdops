class ModifyExpiredColumn < ActiveRecord::Migration
  def self.up
    change_column :contracts, :expired, :boolean, :default => false
  end

  def self.down
    change_column :contracts, :expired, :string
  end
end
