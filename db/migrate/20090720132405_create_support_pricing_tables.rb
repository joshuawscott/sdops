class CreateSupportPricingTables < ActiveRecord::Migration
  def self.up
    create_table :hwdb do |t|
      t.string :part_number
      t.string :description
      t.decimal :list_price, :precision => 10, :scale => 2
      t.integer :modified_user_id
      t.date :modified_at
      t.date :confirm_date
      t.text :notes
    end
    create_table :swdb do |t|
      t.string :part_number
      t.string :description
      t.decimal :phone_price, :precision => 10, :scale => 2
      t.decimal :update_price, :precision => 10, :scale => 2
      t.integer :modified_user_id
      t.date :modified_at
      t.date :confirm_date
      t.text :notes
    end
    add_index :hwdb, :part_number
    add_index :swdb, :part_number
  end

  def self.down
    drop_table :hwdb
    drop_table :swdb
  end
end
