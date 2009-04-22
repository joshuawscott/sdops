class SupportPricingDb < ActiveRecord::Base #:nodoc:
  establish_connection :support_pricing
  self.abstract_class = true
end
