#    t.string "serial_number"
class AppgenOrderSerial < ActiveRecord::Base
  belongs_to :appgen_order_lineitem, :foreign_key => :id
  
  def id
    tracking
  end
end
