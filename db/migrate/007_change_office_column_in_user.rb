class ChangeOfficeColumnInUser < ActiveRecord::Migration
  def self.up
     change_column :users, :office, :integer
     rename_column :users, :office, :office_id
  end

  def self.down
     rename_column :users, :office, :office_id     
     change_column :users, :office, :string, :null => false
  end
end
