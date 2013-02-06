class FootprintsCategory < ActiveRecord::Base
  requires_presence_of :subsystem
  requires_presence_of :main_category
end
