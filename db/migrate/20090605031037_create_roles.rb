class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.string :description

      t.timestamps
    end

    create_table :permissions, :id => false do |t|
      t.integer :role_id
      t.integer :user_id
      t.timestamps
    end
    add_index :permissions, :role_id
    add_index :permissions, :user_id

    require 'active_record/fixtures'
    Fixtures.create_fixtures('db/data', 'roles')

  end

  def self.down
    drop_table :roles
    drop_table :permissions
  end
end
