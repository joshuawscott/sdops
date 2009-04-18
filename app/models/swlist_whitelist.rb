class SwlistWhitelist < ActiveRecord::Base
  validates_uniqueness_of :pattern
  has_many :swproducts

end
