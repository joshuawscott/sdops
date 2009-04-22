# Schema:
#   id          string
#   date_entered  datetime
#   date_modified datetime
#   created_by    string
#   team_id       string
#   deleted       boolean
#   name          string
#   opportunity_type  string
#   campaign_id       string
#   lead_source       string
#   amount            float (MySQL type DOUBLE)
#   amount_backup     string
#   amount_usdollar   float (MySQL type DOUBLE)
#   currency_id       string
#   date_closed       date
#   next_step         string
#   sales_stage       string
#   probability       float (MySQL type DOUBLE)
#   description       text
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
