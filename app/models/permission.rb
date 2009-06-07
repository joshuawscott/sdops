# Schema:
#   roles_id        integer
#   users_id        integer
#   created_at      datetime
#   updated_at      datetime
# JOIN table for Roles & Users
class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  validates_uniqueness_of :user_id, :scope => :role_id
  validates_uniqueness_of :role_id, :scope => :user_id
end
