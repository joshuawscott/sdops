class AddColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :sugar_id, :string
  end

  def self.down
    remove_column :users, :sugar_id
  end
end
