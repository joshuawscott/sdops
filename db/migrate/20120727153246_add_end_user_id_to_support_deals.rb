class AddEndUserIdToSupportDeals < ActiveRecord::Migration
  def self.up
    add_column :support_deals, :end_user_id, :string
  end

  def self.down
    remove_column :support_deals, :end_user_id
  end
end
