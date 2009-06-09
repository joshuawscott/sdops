class AddContactInformationToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :address1, :string
    add_column :contracts, :address2, :string
    add_column :contracts, :address3, :string
    add_column :contracts, :contact_name, :string
    add_column :contracts, :contact_phone, :string
    add_column :contracts, :contact_email, :string
    add_column :contracts, :contact_note, :string
  end

  def self.down
    remove_column :contracts, :contact_note
    remove_column :contracts, :contact_email
    remove_column :contracts, :contact_phone
    remove_column :contracts, :contact_name
    remove_column :contracts, :address3
    remove_column :contracts, :address2
    remove_column :contracts, :address1
  end
end
