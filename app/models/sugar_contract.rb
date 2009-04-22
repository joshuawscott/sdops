# Schema:
#   id                    string
#   name                  string
#   reference_code        string
#   account_id            string
#   start_date            date
#   end_date              date
#   currency_id           string
#   total_contract_value  decimal(26,6)
#   total_contract_value_usdollar decimal(26,6)
#   status                string
#   customer_signed_date  date
#   company_signed_date   date
#   expiration_notice     datetime
#   description           text
#   assigned_user_id      string
#   created_by            string
#   date_entered          datetime
#   date_modified         datetime
#   deleted               boolean
#   modified_user_id      string
#   team_id               string
#   type                  string
class SugarContract < SugarDb
  set_table_name "contracts"
  
end
