class SupportPricingDb < ActiveRecord::Base
  establish_connection :support_pricing
  self.abstract_class = true

end
