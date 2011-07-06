class AddFishbowlSoIdToUpfrontOrder < ActiveRecord::Migration
  def self.up
    add_column :upfront_orders, :fishbowl_so_id, :integer
  end

  def self.down
    remove_column :upfront_orders, :fishbowl_so_id
  end
end
