# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090424154445) do

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "commentable_id",   :limit => 8
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user"
  end

  create_table "contracts", :force => true do |t|
    t.string   "account_id"
    t.string   "account_name"
    t.string   "sales_office_name"
    t.string   "support_office_name"
    t.string   "said"
    t.string   "sdc_ref"
    t.string   "description"
    t.integer  "sales_rep_id",        :limit => 8
    t.string   "sales_office"
    t.string   "support_office"
    t.string   "cust_po_num"
    t.string   "payment_terms"
    t.string   "platform"
    t.decimal  "revenue",                          :precision => 20, :scale => 3
    t.decimal  "annual_hw_rev",                    :precision => 20, :scale => 3
    t.decimal  "annual_sw_rev",                    :precision => 20, :scale => 3
    t.decimal  "annual_ce_rev",                    :precision => 20, :scale => 3
    t.decimal  "annual_sa_rev",                    :precision => 20, :scale => 3
    t.decimal  "annual_dr_rev",                    :precision => 20, :scale => 3
    t.date     "start_date"
    t.date     "end_date"
    t.date     "multiyr_end"
    t.boolean  "expired",                                                         :default => false
    t.string   "hw_support_level_id"
    t.string   "sw_support_level_id"
    t.string   "updates"
    t.integer  "ce_days",             :limit => 8
    t.integer  "sa_days",             :limit => 8
    t.decimal  "discount_pref_hw",                 :precision => 5,  :scale => 3
    t.decimal  "discount_pref_sw",                 :precision => 5,  :scale => 3
    t.decimal  "discount_pref_srv",                :precision => 5,  :scale => 3
    t.decimal  "discount_prepay",                  :precision => 5,  :scale => 3
    t.decimal  "discount_multiyear",               :precision => 5,  :scale => 3
    t.decimal  "discount_ce_day",                  :precision => 5,  :scale => 3
    t.decimal  "discount_sa_day",                  :precision => 5,  :scale => 3
    t.string   "replacement_sdc_ref"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contract_type"
    t.string   "so_number"
    t.string   "po_number"
    t.date     "renewal_sent"
    t.date     "po_received"
    t.decimal  "renewal_amount",                   :precision => 20, :scale => 3
  end

  create_table "dropdowns", :force => true do |t|
    t.string   "dd_name"
    t.string   "filter"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_order", :limit => 8
  end

  create_table "inventory_items", :force => true do |t|
    t.string "item_code"
    t.string "description"
    t.string "serial_number"
    t.string "warehouse"
    t.string "location"
  end

  add_index "inventory_items", ["id"], :name => "tracking", :unique => true

  create_table "io_slots", :force => true do |t|
    t.integer  "server_id"
    t.integer  "slot_number"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "line_items", :force => true do |t|
    t.integer  "contract_id",        :limit => 8
    t.string   "support_type"
    t.string   "product_num"
    t.string   "serial_num"
    t.string   "description"
    t.date     "begins"
    t.date     "ends"
    t.integer  "qty",                :limit => 8
    t.decimal  "list_price",                      :precision => 20, :scale => 3
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "support_provider"
    t.integer  "position"
    t.string   "location"
    t.decimal  "current_list_price",              :precision => 20, :scale => 3
    t.decimal  "effective_price",                 :precision => 20, :scale => 3
  end

  add_index "line_items", ["product_num"], :name => "index_line_items_on_product_num"
  add_index "line_items", ["contract_id"], :name => "index_line_items_on_contract_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "data"
    t.integer  "resource_id",   :limit => 8
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "opportunities", :force => true do |t|
    t.string   "sugar_id"
    t.string   "account_id"
    t.string   "account_name"
    t.string   "opp_type"
    t.string   "name"
    t.text     "description"
    t.decimal  "revenue",      :precision => 20, :scale => 3
    t.decimal  "cogs",         :precision => 20, :scale => 3
    t.decimal  "probability",  :precision => 5,  :scale => 3
    t.string   "status"
    t.string   "modified_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_deals", :force => true do |t|
    t.string   "job_number"
    t.integer  "sugar_opp_id",   :limit => 8
    t.string   "account_id"
    t.string   "account_name"
    t.string   "invoice_number"
    t.decimal  "revenue",                     :precision => 20, :scale => 3
    t.decimal  "cogs",                        :precision => 20, :scale => 3
    t.decimal  "freight",                     :precision => 20, :scale => 3
    t.string   "status"
    t.string   "modified_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "successor_id",   :limit => 8
    t.integer  "predecessor_id", :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servers", :force => true do |t|
    t.string   "model_name"
    t.string   "server_line"
    t.integer  "tier"
    t.integer  "sockets"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "swlist_blacklists", :force => true do |t|
    t.string   "pattern"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "swlist_whitelists", :force => true do |t|
    t.string   "pattern"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "swproducts", :force => true do |t|
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

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "office"
    t.string   "email"
    t.integer  "role",                      :limit => 8
    t.string   "sugar_id"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
