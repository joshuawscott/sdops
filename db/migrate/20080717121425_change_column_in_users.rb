class ChangeColumnInUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :office_id, :string
    rename_column :users, :office_id, :office
  end

  def self.down
    change_column :users, :office, :integer
    rename_column :users, :office, :office_id
  end
end
