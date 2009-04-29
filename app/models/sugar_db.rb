# Abstract class for connecting to the SugarCRM DB
class SugarDb < ActiveRecord::Base
  establish_connection :sugarcrm
  self.abstract_class = true
end
