# Parent class to store connection information for the product pricing server
class PricingDb < ActiveRecord::Base
  establish_connection :pricing
end
