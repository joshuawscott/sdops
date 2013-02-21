class AddSubCategoryToFootprintsCategory < ActiveRecord::Migration
  def self.up
    add_column :footprints_categories, :sub_category, :string
  end

  def self.down
    remove_column :footprints_categories, :sub_category
  end
end
