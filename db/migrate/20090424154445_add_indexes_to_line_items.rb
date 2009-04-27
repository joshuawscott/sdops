class AddIndexesToLineItems < ActiveRecord::Migration
  def self.up
    add_index :line_items, :product_num
    add_index :line_items, :contract_id
  end

  def self.down
    remove_index :line_items, :product_num
    remove_index :line_items, :contract_id
  end
end
