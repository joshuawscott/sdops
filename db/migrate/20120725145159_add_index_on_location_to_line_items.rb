class AddIndexOnLocationToLineItems < ActiveRecord::Migration
  def self.up
    add_index :line_items, :location
  end

  def self.down
    remove_index :line_items, :location
  end
end
