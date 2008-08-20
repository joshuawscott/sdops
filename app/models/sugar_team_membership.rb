class SugarTeamMembership < SugarDb
  set_table_name "team_memberships"
  
  has_one :sugar_team, :foreign_key => :id
  #belongs_to :user, :foreign_key => :user_id
  

end
