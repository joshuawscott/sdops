# Schema
#   id            integer
#   contract_id   integer
#   support_type  string
#   product_num   string
#   serial_num    string
#   description   string
#   begins        date
#   ends          date
#   qty           integer
#   list_price    decimal
#   created_at    datetime
#   updated_at    datetime
#   support_provider  string
#   position      integer
#   location      string
#   current_list_price  decimal
#   effective_price     decimal   
class LineItem < ActiveRecord::Base
  @@support_types = ['HW', 'SW', 'SRV']
  belongs_to :contract
  validates_presence_of :support_type, :in => @@support_types
  validates_presence_of :location, :position

  # Aggregates the locations in LineItems as an Array Object
  def self.locations
    LineItem.find(:all, :select => 'location', :joins => :contract, :conditions => ['contracts.expired = ?', false], :group => 'location').map {|x| x.location.to_s}.sort!
  end

  # OPTIMIZE: hw_revenue_by_location is VERY slow (>15 seconds)
  # Returns a collection of LineItem Objects with the total revenue for each location
  def self.hw_revenue_by_location
    locations = LineItem.find(:all, 
      :select => 'DISTINCT location, 0.0 as revenue', 
      :joins => :contract, 
      :conditions => ['contracts.expired = ?', false], 
      :order => :location)
    rawlist = LineItem.find(:all,
      :select => 'line_items.*, contracts.discount_pref_hw + contracts.discount_prepay + contracts.discount_multiyear AS discount, IFNULL(qty * list_price * 12 ,0.0) AS revenue',
      :joins => :contract,
      :conditions =>
        ['contracts.expired = :expired AND line_items.begins <= :begins AND line_items.ends >= :ends AND support_type = "HW"',
        {:expired => false, :begins => Time.now, :ends => Time.now}])
    locations.each do |l|
      rawlist.each  do |i|
        if l.location == i.location && i.revenue != nil && i.revenue.to_i > 0
          i.discount = i.contract.effective_hw_discount if i.discount.to_f == 0.0
          l.revenue = l.revenue.to_f + (i.revenue.to_f * (1 - i.discount.to_f))
        end
      end
    end
    locations
  end

  # Updates current_list_price for all the LineItem's in the database.
  def self.update_all_current_prices
    
    # Update HW Lines
    lineitems = LineItem.find(:all, :select => "DISTINCT product_num", :joins => :contract, :conditions => "contracts.expired <> true AND support_type = 'HW' AND product_num IS NOT NULL AND product_num NOT LIKE 'label'")
    lineitems.each do |l|
      @cp = SupportPriceHw.current_list_price(l.product_num).list_price
      LineItem.update_all(["current_list_price = ?", @cp], ["product_num = ? AND support_type = 'HW'", l.product_num] )
    end
    
    # Update SW Lines
    lineitems = LineItem.find(:all, :select => "DISTINCT product_num", :joins => :contract, :conditions => "contracts.expired <> true AND support_type = 'SW' AND product_num IS NOT NULL AND product_num NOT LIKE 'label'")
    lineitems.each do |l|
      @cp = SupportPriceSw.current_list_price(l.product_num).list_price
      LineItem.update_all(["current_list_price = ?", @cp], ["product_num = ? AND support_type = 'SW'", l.product_num] )
    end
    # Update SRV Lines
    LineItem.update_all("current_list_price = list_price", "support_type = 'SRV'")
  end

  # Extended List Price (list_price * qty)
  def ext_list_price
    (list_price || 0) * (qty || 0)
  end

  # Extended Current List Price (current_list_price * qty)
  def ext_current_list_price
    (current_list_price || 0) * (qty || 0)
  end

  # Extended Effective Price (effective_list_price * qty)
  def ext_effective_price
    (effective_list_price || 0) * (qty || 0)
  end

  # Returns a SupportPriceHw or SupportPriceSw object, if support_type is 'HW' or 'SW' respectively.
  # If support_type is 'SRV', returns nil.  This method is for updating from the current pricing DB.
  def return_current_info
    ("support_price_" + support_type.downcase).camelize.constantize.current_list_price(product_num) unless support_type == 'SRV'
  end

  def self.support_types
    @@support_types
  end
end
