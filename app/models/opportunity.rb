class Opportunity < ActiveRecord::Base
  belongs_to :sugar_opp, :foreign_key => :sugar_id
  
end
