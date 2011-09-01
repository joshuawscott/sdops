# This is a model that provides commenting on any other model in SD Ops.  To use
# this, you need to add the following to your model:
#   has_many :comments, :as => :commentable
# To add a comment box to the view, you should use the shared comment box:
#   = render :partial => "/shared_views/comments_box", :locals => {:object => @object}
# where <tt>@object</tt> is an instance of the model that has comments.
# In the controller, you need to put the following:
#   @comment = Comment.new
#   @comments = @object.comments
# where <tt>@object</tt> is also an instance of the model that has comments.
#
# ===Schema:
#   body             text
#   commentable_id   integer
#   commentable_type string
#   created_at       datetime
#   updated_at       datetime
#   user             string
class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
end
