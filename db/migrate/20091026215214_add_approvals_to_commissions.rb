class AddApprovalsToCommissions < ActiveRecord::Migration
  def self.up
    add_column :commissions, :approval, :string
    add_column :commissions, :approval_date, :datetime
  end

  def self.down
    remove_column :commissions, :approval_date
    remove_column :commissions, :approval
  end
end
