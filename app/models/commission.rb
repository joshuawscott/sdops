# ===Schema:
#   commissionable_id     integer
#   commissionable_type   string
#   user_id               integer
#   percentage            decimal
#   notes                 text

class Commission < ActiveRecord::Base #:nodoc:
  belongs_to :commissionable, :polymorphic => true
end
