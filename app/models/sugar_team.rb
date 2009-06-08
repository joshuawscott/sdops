# Schema:
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
  set_table_name "teams"
  
  belongs_to :sugar_team_membership
  belongs_to :user
  
  def self.dropdown_list(teams)
    SugarTeam.find(:all, :select => "id, name", :conditions => ["private = 0 AND deleted = 0 AND id IN (?)", teams], :order => 'name')
  end
end
