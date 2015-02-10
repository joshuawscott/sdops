# A SugarOpp is an opportunity (potential sale) in SugarCRM.  We do not use this
# for anything at this time.
# ===Schema
#   id                string
#   date_entered      datetime
#   date_modified     datetime
#   modified_user_id  string
#   assigned_user_id  string
#   created_by        string
#   team_id           string
#   deleted           boolean
#   name              string
#   opportunity_type  string
#   campaign_id       string
#   lead_source       string
#   amount            float
#   amount_backup     string
#   amount_usdollar   float
#   currency_id       string
#   date_closed       date
#   next_step         string
#   sales_stage       string
#   probability       float
#   description       text
#--
# TODO: a new Quote should create or link to an opportunity.
class SugarOpp < SugarDb
  set_table_name "opportunities"

  has_many :sugar_acct_opps, :foreign_key => "opportunity_id"
  has_many :sugar_accts, :through => :sugar_acct_opps, :foreign_key => "opportunity_id"
  has_one :opportunity, :foreign_key => "sugar_id"
  belongs_to :sugar_team, :foreign_key => "team_id"
  belongs_to :sugar_user, :foreign_key => "assigned_user_id"

  def acct_name
    sugar_accts[0].name
  end

  def team_name
    sugar_team.name rescue "N/A"
  end

  def user_name
    sugar_user.name rescue "N/A"
  end

  def weighted_amount
    amount * (probability / 100) rescue 0.0
  end

end
