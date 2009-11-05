#    t.string  "appgen_order_id"
#    t.boolean "has_upfront_support"
#    t.boolean "completed"
#    t.integer "support_deal_id"
class UpfrontOrder < ActiveRecord::Base
  belongs_to :appgen_order
  belongs_to :support_deal
  validates_uniqueness_of :appgen_order_id
  after_save :update_completed
  
  def self.update_from_appgen
    AppgenOrder.find(:all, :joins => "LEFT JOIN upfront_orders ON appgen_orders.id = upfront_orders.appgen_order_id", :conditions => "upfront_orders.id IS NULL").each do |appgen_order|
      @upfront_order = UpfrontOrder.new( :appgen_order_id => appgen_order.id )
      @upfront_order.save
    end
  end

  protected
  def update_completed
    update_attribute(:completed, false) if self.support_deal_id == nil && self.completed == true
  end
  
end
