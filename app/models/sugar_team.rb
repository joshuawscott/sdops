class SugarTeam < SugarDb
  set_table_name "teams"
  
  belongs_to :sugar_team_membership
  belongs_to :user
  
  def self.dropdown_list(role, teams)
    if role >= MANAGER
      SugarTeam.find(:all, :select => "id, name", :conditions => "private = 0 AND deleted = 0 AND id <> 1 ")
    else
      SugarTeam.find(:all, :select => "id, name", :conditions => ["private = 0 AND deleted = 0 AND id IN (?)", teams])
    end
  end
end
