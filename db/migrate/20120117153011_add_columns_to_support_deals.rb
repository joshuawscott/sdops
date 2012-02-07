class AddColumnsToSupportDeals < ActiveRecord::Migration
  def self.up
    add_column :support_deals, :basic_remote_monitoring, :boolean
    add_column :support_deals, :basic_backup_auditing, :boolean
    add_column :support_deals, :primary_ce_id, :integer
  end

  def self.down
    remove_column :support_deals, :primary_ce_id
    remove_column :support_deals, :basic_backup_auditing
    remove_column :support_deals, :basic_remote_monitoring
  end
end
