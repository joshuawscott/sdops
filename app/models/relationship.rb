# JOIN table for Contracts to determine line of succession in Contracts.  Links
# a contract to its successors and predecessors.
# ===Schema
#   id              integer
#   successor_id    integer
#   predecessor_id  integer
#   created_at      datetime
#   updated_at      datetime
class Relationship < ActiveRecord::Base
  belongs_to :successor, :class_name => 'Contract'
  belongs_to :predecessor, :class_name => 'Contract'
end
