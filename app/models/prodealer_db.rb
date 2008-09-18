class ProdealerDb < ActiveRecord::Base
  establish_connection :prodealer
  self.abstract_class ==  true
end
