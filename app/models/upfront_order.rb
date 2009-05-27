#    t.string  "appgen_order_id"
#    t.boolean "has_upfront_support"
#    t.boolean "completed"
#    t.integer "contract_id"
class UpfrontOrder < ActiveRecord::Base
  belongs_to :appgen_order
  belongs_to :contract
  validates_uniqueness_of :appgen_order_id
  def self.update_from_appgen
    AppgenOrder.find(:all, :joins => "LEFT JOIN upfront_orders ON appgen_orders.id = upfront_orders.appgen_order_id", :conditions => "upfront_orders.id IS NULL").each do |appgen_order|
      @upfront_order = UpfrontOrder.new( :appgen_order_id => appgen_order.id )
      @upfront_order.save
    end
  end
end
