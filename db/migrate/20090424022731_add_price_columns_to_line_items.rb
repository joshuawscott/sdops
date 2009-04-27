class AddPriceColumnsToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :current_list_price, :decimal, :precision => 20, :scale => 3
    add_column :line_items, :effective_price, :decimal, :precision => 20, :scale => 3
  end

  def self.down
    remove_column :line_items, :effective_price
    remove_column :line_items, :current_list_price
  end
end
