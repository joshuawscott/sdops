class RenameContractsToSupportDeals < ActiveRecord::Migration
  def self.up
    rename_table(:contracts, :support_deals)
    add_column(:support_deals, :type, :string)
    rename_column(:line_items, :contract_id, :support_deal_id)
    rename_column(:upfront_orders, :contract_id, :support_deal_id)
    SupportDeal.update_all("type = 'Contract'", "1 = 1")
    Comment.update_all("commentable_type = 'SupportDeal'", "commentable_type LIKE 'Contract'")
  end

  def self.down
    rename_table(:support_deals, :contracts)
    remove_column(:contracts, :type)
    rename_column :line_items, :support_deal_id, :contract_id
    rename_column :upfront_orders, :support_deal_id, :contract_id
    Comment.update_all("commentable_type = 'Contract'", "commentable_type LIKE 'SupportDeal'")
  end
end
