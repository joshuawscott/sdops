# JOIN table between SugarAcct and SugarOpp.
# ===Schema
#   id              string
#   opportunity_id  string
#   account_id      string
#   date_modified   string
#   deleted         boolean
class SugarAcctOpp < SugarDb
  set_table_name "accounts_opportunities"

  belongs_to :sugar_acct, :foreign_key => "account_id"
  belongs_to :sugar_opp, :foreign_key => "opportunity_id"
end
