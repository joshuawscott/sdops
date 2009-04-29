# Schema:
#   id          integer
#   pattern     string
#   created_at  datetime
#   updated_at  datetime
class SwlistWhitelist < ActiveRecord::Base
  validates_uniqueness_of :pattern
  has_many :swproducts

end
