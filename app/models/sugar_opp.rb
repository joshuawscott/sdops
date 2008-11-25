class SugarOpp < SugarDb
  set_table_name "opportunities"
  
  has_many :sugar_acct_opps, :foreign_key => "opportunity_id"
  has_many :sugar_accts, :through => :sugar_acct_opps, :foreign_key => "opportunity_id"
  has_one :opportunity, :foreign_key => "sugar_id"
  has_one :sugar_team
  
  def acct_name
    sugar_accts[0].name
  end

  def team_name
    SugarTeam.find(:first, :conditions => ["id = ? and deleted = 0", team_id]).name
  end

  def user_name
    SugarUser.find(:first, :conditions => ["id = ? and deleted = 0", assigned_user_id]).name
  end
  
end
