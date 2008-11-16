class CreateOpportunities < ActiveRecord::Migration
  def self.up
    create_table :opportunities do |t|
      t.string :sugar_id
      t.string :account_id
      t.string :account_name
      t.string :opp_type
      t.string :name
      t.text :description
      t.integer :revenue
      t.integer :cogs
      t.integer :probability
      t.string :status
      t.string :modified_by
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :opportunities
  end
end
