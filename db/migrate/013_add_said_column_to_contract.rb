class AddSaidColumnToContract < ActiveRecord::Migration
  def self.up
    add_column :contracts, :said, :string
  end

  def self.down
    remove_column :contracts, :said
  end
end
