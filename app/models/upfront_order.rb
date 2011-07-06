#    t.string  "appgen_order_id"
#    t.boolean "has_upfront_support"
#    t.boolean "completed"
#    t.integer "support_deal_id"
#    t.integer "fishbowl_so_id"
class UpfrontOrder < ActiveRecord::Base
  belongs_to :appgen_order
  belongs_to :support_deal
  belongs_to :fishbowl_so
  validates_uniqueness_of :appgen_order_id, :allow_nil => true
  validates_uniqueness_of :fishbowl_so_id, :allow_nil => true
  after_save :update_completed

  def linked_order
    unless appgen_order_id.nil?
      @linked_order = self.appgen_order
    end
    unless fishbowl_so_id.nil?
      @linked_order = self.fishbowl_so
    end
    @linked_order
  end

  def self.update_from_appgen
    AppgenOrder.find(:all, :joins => "LEFT JOIN upfront_orders ON appgen_orders.id = upfront_orders.appgen_order_id", :conditions => "upfront_orders.id IS NULL").each do |appgen_order|
      @upfront_order = UpfrontOrder.new( :appgen_order_id => appgen_order.id )
      @upfront_order.save
    end
  end

  #Fetches and updates the upfront order entries from fishbowl.
  def self.update_from_fishbowl
    max_id = self.find(:first, :select => "MAX(fishbowl_so_id) as max_id").max_id.to_i
    #new_fb_sos = FishbowlSo.find(:all, :params => {:id => (max_id+1..max_id+11).to_a } )
    new_fb_sos = FishbowlSo.find(:all)
    new_fb_sos.each do |fb_so|
      @upfront_order = self.new
      @upfront_order.fishbowl_so = fb_so
      @upfront_order.save #this fails silently if it's a duplicate, thus no need to check for dupes before.
    end
  end

  protected
  def update_completed
    update_attribute(:completed, false) if self.support_deal_id == nil && self.completed == true
  end
  
end
