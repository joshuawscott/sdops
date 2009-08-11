class CreateSubcontractors < ActiveRecord::Migration
  def self.up
    create_table :subcontractors do |t|
      t.string :name
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone_work
      t.string :contact_phone_mobile
      t.string :phone
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :postalcode
      t.string :country
      t.text :note
      t.timestamps
    end
  end

  def self.down
    drop_table :subcontractors
  end
end
