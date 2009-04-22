# Schema:
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
class Opportunity < ActiveRecord::Base
  belongs_to :sugar_opp, :foreign_key => :sugar_id
  
end
