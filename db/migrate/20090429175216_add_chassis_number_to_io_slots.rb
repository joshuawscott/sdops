class AddChassisNumberToIoSlots < ActiveRecord::Migration
  def self.up
    add_column :io_slots, :chassis_number, :integer
  end

  def self.down
    remove_column :io_slots, :chassis_number
  end
end
