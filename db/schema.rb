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

ActiveRecord::Schema.define(:version => 20080818123555) do

  create_table "contracts", :force => true do |t|
    t.string   "sdc_ref"
    t.string   "description"
    t.integer  "sales_rep_id",        :limit => 11
    t.string   "sales_office"
    t.string   "support_office"
    t.string   "account_id"
    t.string   "cust_po_num"
    t.string   "payment_terms"
    t.string   "platform"
    t.integer  "revenue",             :limit => 10
    t.integer  "annual_hw_rev",       :limit => 10
    t.integer  "annual_sw_rev",       :limit => 10
    t.integer  "annual_ce_rev",       :limit => 10
    t.integer  "annual_sa_rev",       :limit => 10
    t.integer  "annual_dr_rev",       :limit => 10
    t.date     "start_date"
    t.date     "end_date"
    t.date     "multiyr_end"
    t.string   "expired"
    t.string   "hw_support_level_id"
    t.string   "sw_support_level_id"
    t.string   "updates"
    t.integer  "ce_days",             :limit => 11
    t.integer  "sa_days",             :limit => 11
    t.integer  "discount_pref_hw",    :limit => 10
    t.integer  "discount_pref_sw",    :limit => 10
    t.integer  "discount_prepay",     :limit => 10
    t.integer  "discount_multiyear",  :limit => 10
    t.integer  "discount_ce_day",     :limit => 10
    t.integer  "discount_sa_day",     :limit => 10
    t.string   "replacement_sdc_ref"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "said"
    t.string   "account_name"
    t.string   "sales_office_name"
    t.string   "support_office_name"
  end

  create_table "dropdowns", :force => true do |t|
    t.string   "dd_name"
    t.string   "filter"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_order", :limit => 11
  end

  create_table "line_items", :force => true do |t|
    t.integer  "contract_id",      :limit => 11
    t.string   "support_type"
    t.string   "product_num"
    t.string   "serial_num"
    t.string   "description"
    t.date     "begins"
    t.date     "ends"
    t.integer  "qty",              :limit => 11
    t.integer  "list_price",       :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "support_provider"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "data"
    t.integer  "resource_id",   :limit => 11
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
    t.integer  "revenue",      :limit => 11
    t.integer  "cogs",         :limit => 11
    t.integer  "probability",  :limit => 11
    t.string   "status"
    t.string   "modified_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_deals", :force => true do |t|
    t.string   "job_number"
    t.integer  "sugar_opp_id",   :limit => 11
    t.string   "account_id"
    t.string   "account_name"
    t.string   "invoice_number"
    t.integer  "revenue",        :limit => 11
    t.integer  "cogs",           :limit => 11
    t.integer  "freight",        :limit => 11
    t.string   "status"
    t.string   "modified_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "successor_id",   :limit => 11
    t.integer  "predecessor_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "office"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "role",                      :limit => 11
    t.string   "sugar_id"
  end

end
