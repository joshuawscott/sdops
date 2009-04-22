# Schema:
#   id                string
#   date_entered      datetime
#   date_modified     datetime
#   modified_user_id  string
#   assigned_user_id  string
#   created_by        string
#   name              string
#   parent_id         string
#   account_type      string
#   industry          string
#   annual_revenue    string
#   phone_fax         string
#   billing_address_street      string
#   billing_address_city        string
#   billing_address_state       string
#   billing_address_postalcode  string
#   billing_address_country     string
#   description       text
#   rating            string
#   phone_office      string
#   phone_alternate   string
#   email1            string
#   email2            string
#   website           string
#   ownership         string
#   employees         string
#   sic_code          string
#   ticker_symbol     string
#   shipping_address_street       string
#   shipping_address_city         string
#   shipping_address_state        string
#   shipping_address_postalcode   string
#   shipping_address_country      string
#   deleted       boolean
#   campaign_id   string
#   team_id       string
class SugarAcct < SugarDb
  set_table_name "accounts"
  
  has_many :sugar_acct_opps, :foreign_key => "account_id"
  has_many :sugar_opps, :through => :sugar_acct_opps, :foreign_key => "account_id"
  has_many :contracts
  
end
