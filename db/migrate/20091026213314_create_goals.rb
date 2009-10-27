class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.string :type
      t.string :description
      t.string :sales_office
      t.string :sales_office_name
      t.decimal :amount, :precision => 20, :scale => 2
      t.date :start_date
      t.date :end_date
      t.string :periodicity

      t.timestamps
    end
  end

  def self.down
    drop_table :goals
  end
end
