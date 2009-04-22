# Schema:
#   body             text
#   commentable_id   integer
#   commentable_type string
#   created_at       datetime
#   updated_at       datetime
#   user             string
class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
end
