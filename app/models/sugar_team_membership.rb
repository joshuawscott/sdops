# Schema:
#   id              string
#   date_modified   datetime
#   team_id         string
#   user_id         string
#   explicit_assign boolean
#   implicit_assign boolean
#   deleted         boolean
class SugarTeamMembership < SugarDb
  set_table_name "team_memberships"
  
  has_one :sugar_team, :foreign_key => :id
  #belongs_to :user, :foreign_key => :user_id
  

end
