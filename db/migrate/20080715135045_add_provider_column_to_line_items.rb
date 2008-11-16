class AddProviderColumnToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :support_provider, :string
  end

  def self.down
    remove_column :line_items, :support_provider
  end
end
