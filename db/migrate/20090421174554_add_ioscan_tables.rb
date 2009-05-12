class AddIoscanTables < ActiveRecord::Migration
  def self.up
    create_table "io_slots" do |t|
      t.integer  "server_id"
      t.integer  "slot_number"
      t.string   "path"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "description"
    end

    create_table "servers" do |t|
      t.string   "model_name"
      t.string   "server_line"
      t.integer  "tier"
      t.integer  "sockets"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "swlist_blacklists" do |t|
      t.string   "pattern"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "swlist_whitelists" do |t|
      t.string   "pattern"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "swproducts" do |t|
      t.string   "product_number"
      t.string   "license_type"
      t.integer  "tier"
      t.string   "license_product"
      t.integer  "swlist_whitelist_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "explanation"
      t.string   "server_line"
    end
  end
  
  def self.down
    drop_table :io_slots
    drop_table :servers
    drop_table :swlist_blacklists
    drop_table :swlist_whitelists
    drop_table :swproducts
  end
end
