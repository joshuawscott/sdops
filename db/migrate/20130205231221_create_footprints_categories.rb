class CreateFootprintsCategories < ActiveRecord::Migration
  def self.up
    create_table :footprints_categories do |t|
      t.string :subsystem
      t.string :main_category

      t.timestamps
    end
  end

  def self.down
    drop_table :footprints_categories
  end
end
