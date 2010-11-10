class AddTlciToSupportPriceDb < ActiveRecord::Migration
  def self.up
    add_column :hwdb, :tlci, :boolean
    add_column :swdb, :tlci, :boolean
  end

  def self.down
    remove_column :hwdb, :tlci
    remove_column :swdb, :tlci
  end
end
