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

ActiveRecord::Schema.define(:version => 20110718134005) do

  create_table "appgen_order_lineitems", :force => true do |t|
    t.string  "appgen_order_id",                                :null => false
    t.string  "part_number"
    t.string  "description"
    t.integer "quantity"
    t.decimal "price",           :precision => 20, :scale => 5
    t.decimal "discount",        :precision => 7,  :scale => 2
  end

  add_index "appgen_order_lineitems", ["id"], :name => "index_appgen_order_lineitems_on_id", :unique => true
  add_index "appgen_order_lineitems", ["appgen_order_id"], :name => "index_appgen_order_lineitems_on_appgen_order_id"

  create_table "appgen_order_serials", :force => true do |t|
    t.string "serial_number"
  end

  add_index "appgen_order_serials", ["id"], :name => "index_appgen_order_serials_on_id", :unique => true

  create_table "appgen_orders", :force => true do |t|
    t.integer "cust_code"
    t.string  "cust_name"
    t.string  "address2"
    t.string  "address3"
    t.string  "address4"
    t.string  "cust_po_number"
    t.date    "ship_date"
    t.decimal "net_discount",   :precision => 7,  :scale => 2
    t.decimal "sub_total",      :precision => 20, :scale => 5
    t.string  "sales_rep"
  end

  add_index "appgen_orders", ["id"], :name => "index_appgen_orders_on_id", :unique => true

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "changes"
    t.integer  "version",        :default => 0
    t.datetime "created_at"
  end

  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "commentable_id",   :limit => 8
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user"
  end

  create_table "commissions", :force => true do |t|
    t.integer  "commissionable_id"
    t.string   "commissionable_type"
    t.integer  "user_id"
    t.integer  "percentage",          :limit => 10, :precision => 10, :scale => 0
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "approval"
    t.datetime "approval_date"
  end

  create_table "dropdowns", :force => true do |t|
    t.string   "dd_name"
    t.string   "filter"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_order", :limit => 8
  end

  create_table "goals", :force => true do |t|
    t.string   "type"
    t.string   "description"
    t.string   "sales_office"
    t.string   "sales_office_name"
    t.decimal  "amount",            :precision => 20, :scale => 2
    t.date     "start_date"
    t.date     "end_date"
    t.string   "periodicity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hwdb", :force => true do |t|
    t.string  "part_number"
    t.string  "description"
    t.decimal "list_price",           :precision => 10, :scale => 2
    t.integer "modified_user_id"
    t.date    "modified_at"
    t.date    "confirm_date"
    t.text    "notes"
    t.integer "manufacturer_line_id"
    t.boolean "tlci"
  end

  add_index "hwdb", ["part_number"], :name => "index_hwdb_on_part_number"

  create_table "inventory_items", :force => true do |t|
    t.string "item_code"
    t.string "description"
    t.string "serial_number"
    t.string "warehouse"
    t.string "location"
    t.string "manufacturer"
  end

  add_index "inventory_items", ["id"], :name => "tracking", :unique => true

  create_table "inventory_warehouses", :id => false, :force => true do |t|
    t.string "code"
    t.string "description"
  end

  add_index "inventory_warehouses", ["code"], :name => "index_inventory_warehouses_on_code", :unique => true

  create_table "invoice_payments", :force => true do |t|
    t.integer "invoice_id"
    t.integer "payment_id"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "invoiceable_id"
    t.string   "invoiceable_type"
    t.integer  "appgen_cust_number"
    t.string   "invoice_number"
    t.date     "invoice_date"
    t.integer  "invoice_amount",     :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "io_slots", :force => true do |t|
    t.integer  "server_id"
    t.integer  "slot_number"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "chassis_number"
  end

  create_table "line_items", :force => true do |t|
    t.integer  "support_deal_id",    :limit => 8
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
    t.string   "note"
    t.integer  "subcontract_id"
    t.decimal  "subcontract_cost",                :precision => 20, :scale => 2
  end

  add_index "line_items", ["product_num"], :name => "index_line_items_on_product_num"
  add_index "line_items", ["support_deal_id"], :name => "index_line_items_on_contract_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "data"
    t.integer  "resource_id",   :limit => 8
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manufacturer_lines", :force => true do |t|
    t.string   "name"
    t.integer  "manufacturer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manufacturers", :force => true do |t|
    t.string   "name"
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

  create_table "payments", :force => true do |t|
    t.integer  "appgen_cust_number"
    t.string   "payment_number"
    t.date     "payment_date"
    t.integer  "payment_amount",     :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :id => false, :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["role_id"], :name => "index_permissions_on_role_id"
  add_index "permissions", ["user_id"], :name => "index_permissions_on_user_id"

  create_table "product_deals", :force => true do |t|
    t.string   "job_number"
    t.integer  "sugar_opp_id",      :limit => 8
    t.string   "account_id"
    t.string   "account_name"
    t.string   "invoice_number"
    t.decimal  "revenue",                        :precision => 20, :scale => 3
    t.decimal  "cogs",                           :precision => 20, :scale => 3
    t.decimal  "other_costs",                    :precision => 20, :scale => 3
    t.string   "status"
    t.string   "modified_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sales_office"
    t.string   "sales_office_name"
    t.string   "customer_po"
    t.date     "customer_po_date"
    t.string   "description"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "successor_id",   :limit => 8
    t.integer  "predecessor_id", :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
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

  create_table "subcontractors", :force => true do |t|
    t.string   "name"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone_work"
    t.string   "contact_phone_mobile"
    t.string   "phone"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "postalcode"
    t.string   "country"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcontracts", :force => true do |t|
    t.integer  "subcontractor_id"
    t.string   "customer_number"
    t.string   "site_number"
    t.string   "sales_order_number"
    t.string   "description"
    t.string   "quote_number"
    t.string   "sourcedirect_po_number"
    t.decimal  "cost",                   :precision => 20, :scale => 2
    t.string   "hw_response_time"
    t.string   "sw_response_time"
    t.string   "hw_repair_time"
    t.string   "hw_coverage_days"
    t.string   "sw_coverage_days"
    t.string   "hw_coverage_hours"
    t.string   "sw_coverage_hours"
    t.boolean  "parts_provided"
    t.boolean  "labor_provided"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "support_deals", :force => true do |t|
    t.string   "account_id"
    t.string   "account_name"
    t.string   "sales_office_name"
    t.string   "support_office_name"
    t.string   "said"
    t.string   "sdc_ref"
    t.string   "description"
    t.integer  "sales_rep_id",         :limit => 8
    t.string   "sales_office"
    t.string   "support_office"
    t.string   "cust_po_num"
    t.string   "payment_terms"
    t.string   "platform"
    t.decimal  "revenue",                            :precision => 20, :scale => 3
    t.decimal  "annual_hw_rev",                      :precision => 20, :scale => 3
    t.decimal  "annual_sw_rev",                      :precision => 20, :scale => 3
    t.decimal  "annual_ce_rev",                      :precision => 20, :scale => 3
    t.decimal  "annual_sa_rev",                      :precision => 20, :scale => 3
    t.decimal  "annual_dr_rev",                      :precision => 20, :scale => 3
    t.date     "start_date"
    t.date     "end_date"
    t.date     "multiyr_end"
    t.boolean  "expired",                                                           :default => false
    t.string   "hw_support_level_id"
    t.string   "sw_support_level_id"
    t.string   "updates"
    t.integer  "ce_days",              :limit => 8
    t.integer  "sa_days",              :limit => 8
    t.decimal  "discount_pref_hw",                   :precision => 5,  :scale => 3
    t.decimal  "discount_pref_sw",                   :precision => 5,  :scale => 3
    t.decimal  "discount_pref_srv",                  :precision => 5,  :scale => 3
    t.decimal  "discount_prepay",                    :precision => 5,  :scale => 3
    t.decimal  "discount_multiyear",                 :precision => 5,  :scale => 3
    t.decimal  "discount_ce_day",                    :precision => 5,  :scale => 3
    t.decimal  "discount_sa_day",                    :precision => 5,  :scale => 3
    t.string   "replacement_sdc_ref"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contract_type"
    t.string   "so_number"
    t.string   "po_number"
    t.date     "renewal_sent"
    t.date     "po_received"
    t.decimal  "renewal_amount",                     :precision => 20, :scale => 3
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.string   "contact_note"
    t.integer  "new_business_dollars", :limit => 10, :precision => 10, :scale => 0
    t.string   "type"
    t.decimal  "list_price_increase",                :precision => 5,  :scale => 3
  end

  create_table "swdb", :force => true do |t|
    t.string  "part_number"
    t.string  "description"
    t.decimal "phone_price",          :precision => 10, :scale => 2
    t.decimal "update_price",         :precision => 10, :scale => 2
    t.integer "modified_user_id"
    t.date    "modified_at"
    t.date    "confirm_date"
    t.text    "notes"
    t.integer "manufacturer_line_id"
    t.boolean "tlci"
  end

  add_index "swdb", ["part_number"], :name => "index_swdb_on_part_number"

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

  create_table "upfront_orders", :force => true do |t|
    t.string  "appgen_order_id"
    t.boolean "has_upfront_support", :default => true
    t.boolean "completed",           :default => false
    t.integer "support_deal_id"
    t.integer "fishbowl_so_id"
  end

  add_index "upfront_orders", ["appgen_order_id"], :name => "index_upfront_orders_on_appgen_order_id", :unique => true

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

  create_table "v_config_items", :force => true do |t|
    t.string  "product_num"
    t.string  "supporttype",      :limit => 8
    t.string  "description"
    t.string  "support_level"
    t.string  "account_name"
    t.integer "support_deal_id",  :limit => 8
    t.string  "serial_num"
    t.string  "location"
    t.string  "account_id"
    t.string  "support_provider"
  end

end
