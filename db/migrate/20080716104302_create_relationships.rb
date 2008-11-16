class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :successor_id
      t.integer :predecessor_id

      t.timestamps
    end
  end

  def self.down
    drop_table :relationships
  end
end
