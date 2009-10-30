# Schema:
#    t.string  "appgen_order_id",                                :null => false
#    t.string  "part_number"
#    t.string  "description"
#    t.integer "quantity"
#    t.decimal "price",           :precision => 20, :scale => 5
#    t.decimal "discount",        :precision => 7,  :scale => 2
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
end
