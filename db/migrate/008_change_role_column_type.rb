class ChangeRoleColumnType < ActiveRecord::Migration
  def self.up
    change_column :users, :role, :integer
  end

  def self.down
    change_column :users, :role, :string
  end
end
