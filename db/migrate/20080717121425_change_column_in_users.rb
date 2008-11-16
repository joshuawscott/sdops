class ChangeColumnInUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :office_id, :string, :null => false
    rename_column :users, :office_id, :office
  end

  def self.down
    change_column :users, :office, :integer, :null => false
    rename_column :users, :office, :office_id
  end
end
