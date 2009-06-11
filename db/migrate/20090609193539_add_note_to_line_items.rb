class AddNoteToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :note, :string
  end

  def self.down
    remove_column :line_items, :note
  end
end
