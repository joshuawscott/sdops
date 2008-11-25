class AddLocationToLineItem < ActiveRecord::Migration
  def self.up
    add_column :line_items, :location, :string
  end

  def self.down
    remove_column :line_items, :location
  end
end
