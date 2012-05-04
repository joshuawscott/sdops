class CreateIndexOnSupportType < ActiveRecord::Migration
  def self.up
    add_index :support_deals, :type
  end

  def self.down
    remove_index :support_deals, :type
  end
end
