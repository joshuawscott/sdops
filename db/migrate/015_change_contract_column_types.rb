class ChangeContractColumnTypes < ActiveRecord::Migration
  def self.up
    change_column :users, :office_id, :string
    #change_column :contracts, :primary_office, :string
    change_column :contracts, :hw_support_level_id, :string
    change_column :contracts, :sw_support_level_id, :string
    change_column :contracts, :payment_terms, :string
  end

  def self.down
    change_column :users, :office_id, :integer
    #change_column :contracts, :primary_office, :integer
    change_column :contracts, :hw_support_level_id, :integer
    change_column :contracts, :sw_support_level_id, :integer
    change_column :contracts, :payment_terms, :integer
  end
end
