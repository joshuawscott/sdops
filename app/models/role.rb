class Role < ActiveRecord::Base

  has_many :permissions
  has_many :users, :through => :permissions
  validates_uniqueness_of :name



end
