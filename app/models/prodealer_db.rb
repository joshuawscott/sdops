# Not used.
class ProdealerDb < ActiveRecord::Base #:nodoc:
  establish_connection :prodealer
  self.abstract_class ==  true
end
