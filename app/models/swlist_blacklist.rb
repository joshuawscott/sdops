# Schema
#   id          integer
#   pattern     string
#   created_at  datetime
#   updated_at  datetime
class SwlistBlacklist < ActiveRecord::Base
  validates_uniqueness_of :pattern
end
