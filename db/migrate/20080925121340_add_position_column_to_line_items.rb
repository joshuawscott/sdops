class AddPositionColumnToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :position, :integer
  end

  def self.down
    remove_column :line_items, :position
  end
end
