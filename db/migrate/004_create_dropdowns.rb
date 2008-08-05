class CreateDropdowns < ActiveRecord::Migration
  def self.up
    create_table :dropdowns do |t|
      t.string :dd_name, :filter, :label
      t.integer :sort_order
      t.timestamps
    end
  end

  def self.down
    drop_table :dropdowns
  end
end
