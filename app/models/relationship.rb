class Relationship < ActiveRecord::Base
  belongs_to :successor, :class_name => 'Contract'
  belongs_to :predecessor, :class_name => 'Contract'
end
