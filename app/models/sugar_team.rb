# a SugarTeam is used for access control in SugarCRM.  SD Ops checks the team
# membership of a user when determining what Contract(s) can be seen from the
# main contracts page.
# ===Schema
#   id                string
#   name              string
#   date_entered      datetime
#   date_modified     datetime
#   modified_user_id  string
#   created_by        string
#   private           boolean
#   description       text
#   deleted           boolean
class SugarTeam < SugarDb
  set_table_name "team"
  
  belongs_to :sugar_team_membership
  has_many :sugar_team_memberships, :foreign_key => 'team_id'
  has_many :sugar_users, :through => :sugar_team_memberships
  belongs_to :user

  # Finds list suitable for populating an HTML dropdown list
  # based on an array of ids.
  def self.dropdown_list(teams)
    SugarTeam.find(:all, :select => "id, name", :conditions => ["deleted = 0 AND id IN (?)", teams], :order => 'name')
  end
end
