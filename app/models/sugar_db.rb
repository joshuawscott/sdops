class SugarDb < ActiveRecord::Base
  establish_connection :sugarcrm
  self.abstract_class ==  true
end
