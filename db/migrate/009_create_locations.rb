class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.string :description
      t.text :data
      t.integer :resource_id
      t.string :resource_type

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
