class IoSlot < ActiveRecord::Base
  belongs_to :server
  validates_uniqueness_of :path, :scope => [:server_id]

end
