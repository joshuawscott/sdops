class CreateManufacturerLines < ActiveRecord::Migration
  def self.up
    create_table :manufacturer_lines do |t|
      t.string :name
      t.integer :manufacturer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :manufacturer_lines
  end
end
