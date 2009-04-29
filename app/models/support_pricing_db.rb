# Abstract Class for connecting to support_pricing DB
class SupportPricingDb < ActiveRecord::Base
  establish_connection :support_pricing
  self.abstract_class = true

end
