class CreateCommission < ActiveRecord::Migration
  def self.up
    create_table :commissions do |t|
      t.integer :commissionable_id
      t.string :commissionable_type
      t.integer :user_id
      t.decimal :percentage
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :commissions
  end
end
