# Work in Progress?
# ===Schema
#   id            integer
#   sugar_id      string
#   account_id    string
#   account_name  string
#   opp_type      string
#   name          string
#   description   text
#   revenue       decimal
#   cogs          decimal
#   probability   decimal
#   status        string
#   modified_by   string
#   created_at    datetime
#   updated_at    datetime
class Opportunity < ActiveRecord::Base #:nodoc:
  belongs_to :sugar_opp, :foreign_key => :sugar_id
  belongs_to :sugar_acct, :foreign_key => :account_id
  
end
