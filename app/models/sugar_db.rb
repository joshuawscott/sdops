class SugarDb < ActiveRecord::Base #:nodoc:
  establish_connection :sugarcrm
  self.abstract_class = true
end
