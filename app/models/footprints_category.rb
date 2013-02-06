class FootprintsCategory < ActiveRecord::Base
  validates_presence_of :subsystem
  validates_presence_of :main_category
end
