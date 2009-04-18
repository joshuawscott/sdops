class SwlistBlacklist < ActiveRecord::Base
  validates_uniqueness_of :pattern
end
