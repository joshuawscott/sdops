# DEPRECATED - this was a table populated by a cronjob that pulled data from the
# Appgen accounting system.  We no longer use this, and it has been replaced by
# the Fishbowl and Fishbowl* classes.
# ===Schema
#   serial_number string
class AppgenOrderSerial < ActiveRecord::Base
  belongs_to :appgen_order_lineitem, :foreign_key => :id

  def id
    tracking
  end
end
