# ==DEPRECATED
# This was a table populated by a cronjob that pulled data from the
# Appgen accounting system.  We no longer use this, and it has been replaced by
# the Fishbowl and Fishbowl* classes.
# ===Schema:
#   appgen_order_id string
#   part_number     string
#    description    string
#    quantity       integer
#    price          decimal(20,5)
#    discount       decimal(7,2)
class AppgenOrderLineitem < ActiveRecord::Base
  belongs_to :appgen_order
  has_one :appgen_order_serial, :foreign_key => :id
  belongs_to :sugar_acct
  belongs_to :contract

  def hwchecked
    # if the first letter is A, then it's checked
    return "true" if part_number[0] == 65 || (part_number[0] >= 48 && part_number[0] <= 57)
    'false'
  end

  def swchecked
    # if the first letter is B, then it's checked
    return "true" if part_number[0] == 66
    'false'
  end

  #consistent interface between this and fishbowl_so
  def serialnum
    self.appgen_order_serial.serial_number
  end

end
