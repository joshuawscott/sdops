class LineItem < ActiveRecord::Base
  belongs_to :contract
  def self.locations(role,teams)
    if role >= MANAGER
      LineItem.find(:all, :select => 'location').map {|x| x.location}.uniq!.sort!
    else
      SugarTeam.dropdown_list(role,teams).map {|x| x.name}
    end
  end
end
