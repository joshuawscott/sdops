class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.integer :contract_id
      t.string :support_type
      t.string :product_num
      t.string :serial_num
      t.string :description
      t.date :begins
      t.date :ends
      t.integer :qty
      t.integer :list_price

      t.timestamps
    end
  end

  def self.down
    drop_table :line_items
  end
end
