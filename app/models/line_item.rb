# Schema
#   id            integer
#   support_deal_id   integer
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
  belongs_to :support_deal
  belongs_to :subcontract
  validates_presence_of :support_type, :in => @@support_types
  validates_presence_of :location, :position, :product_num
  acts_as_audited :except => [:effective_price, :position]
  acts_as_list :scope => :support_deal
  # Aggregates the locations in LineItems as an Array Object
  def contract
    support_deal
  end

  def quote
    support_deal
  end

  def self.locations
    LineItem.find(:all, :select => 'location', :joins => :support_deal, :conditions => ['support_deals.expired = ?', false], :group => 'location').map {|x| x.location.to_s}.sort!
  end

  # OPTIMIZE: hw_revenue_by_location is VERY slow (>15 seconds)
  # Returns a collection of LineItem Objects with the total revenue for each location
  def self.hw_revenue_by_location(effective_time = Time.now)

    locations = LineItem.find(:all, :select => 'line_items.*, SUM(effective_price * qty * 12) AS revenue', :conditions => ["begins <= :time AND ends >= :time AND support_type = 'HW'", {:time => effective_time}], :group => 'location ASC' )
    locations.each do |l|
      l.revenue = l.revenue.to_f
    end
    locations
    # OLD METHOD:
    #locations = LineItem.find(:all,
    #  :select => 'DISTINCT location, 0.0 as revenue',
    #  :joins => :support_deal,
    #  :conditions => ['support_deals.expired = ?', false],
    #  :order => :location)
    #rawlist = LineItem.find(:all,
    #  :select => 'line_items.*, support_deals.discount_pref_hw + support_deals.discount_prepay + support_deals.discount_multiyear AS discount, IFNULL(qty * list_price * 12 ,0.0) AS revenue',
    #  :joins => :support_deal,
    #  :conditions =>
    #    ['support_deals.expired = :expired AND line_items.begins <= :begins AND line_items.ends >= :ends AND support_type = "HW"',
    #    {:expired => false, :begins => effective_time, :ends => effective_time}])
    #locations.each do |l|
    #  rawlist.each  do |i|
    #    if l.location == i.location && i.revenue != nil && i.revenue.to_i > 0
    #      i.discount = i.support_deal.effective_hw_discount if i.discount.to_f == 0.0
    #      l.revenue = l.revenue.to_f + (i.revenue.to_f * (1 - i.discount.to_f))
    #    end
    #  end
    #end
    #locations
  end

  # Updates current_list_price for all the LineItem's in the database.
  def self.update_all_current_prices

    # Update HW Lines
    lineitems = LineItem.find(:all, :select => "DISTINCT product_num", :joins => :support_deal, :conditions => "support_deals.expired <> true AND support_type = 'HW' AND product_num IS NOT NULL AND product_num NOT LIKE 'label'")
    lineitems.each do |l|
      @cp = HwSupportPrice.current_list_price(l.product_num).list_price
      LineItem.update_all(["current_list_price = ?", @cp], ["product_num = ? AND support_type = 'HW'", l.product_num] )
    end

    # Update SW Lines
    lineitems = LineItem.find(:all, :select => "DISTINCT product_num", :joins => :support_deal, :conditions => "support_deals.expired <> true AND support_type = 'SW' AND product_num IS NOT NULL AND product_num NOT LIKE 'label'")
    lineitems.each do |l|
      @cp = SwSupportPrice.current_list_price(l.product_num).list_price
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

  # Returns a HwSupportPrice or SwSupportPrice object, if support_type is 'HW' or 'SW' respectively.
  # If support_type is 'SRV', returns nil.  This method is for updating from the current pricing DB.
  def return_current_info
    (support_type.downcase + "_support_price").camelize.constantize.current_list_price(product_num) unless support_type == 'SRV'
  end

  def self.support_types
    @@support_types
  end

  def remove_from(associated_model)
    self.send(associated_model.class.to_s.foreign_key + '=', nil)
    save(false)
  end

  # returns a float corresponding to the number of months that the line item is valid.
  def effective_months
    return 0 if start_date > end_date
    y = (end_date.year - start_date.year) * 12
    m = (end_date.mon - start_date.mon)
    last_month_days = ((end_date.day - end_date.beginning_of_month.day) + 1).to_f / end_date.end_of_month.day
    first_month_days = ((start_date.end_of_month.day - start_date.day) + 1).to_f / start_date.end_of_month.day
    first_and_last = start_date.day - 1 == end_date.day ? 1 : last_month_days + first_month_days
    (y + m + first_and_last) - 1
  end

  # returns the effective start date, taking into account the parent support_deal's start & end dates
  def start_date
    return begins if support_deal.nil?
    self.begins ||= support_deal.start_date
    return support_deal.start_date > begins ? support_deal.start_date : begins
  end

  # returns the effective end date, taking into account the parent support_deal's end date
  def end_date
    return ends if support_deal.nil?
    self.ends ||= support_deal.end_date
    return support_deal.end_date < ends ? support_deal.end_date : ends
  end

  def self.sparesreq(office_name)
    @lineitems = LineItem.find(:all,
      :select => 'l.product_num, l.description, sum(l.qty) as count',
      :conditions => ['l.support_provider = "Sourcedirect" AND l.location = ? AND l.support_type = "HW" AND l.product_num <> "LABEL" AND (l.ends > CURDATE() AND l.begins < ADDDATE(CURDATE(), INTERVAL 30 DAY) OR c.expired <> true)', office_name],
      :joins => 'as l inner join support_deals c on c.id = l.support_deal_id',
      :group => 'l.product_num')
  end

  def qty_instock(office_name=nil)
    if office_name.nil?
      InventoryItem.count(:conditions => ['item_code = ?', base_product])
    else
      wc = InventoryItem.warehouse_code_for(office_name)
      InventoryItem.count(:conditions => ['item_code = ? AND warehouse = ?', base_product, wc])
    end
  end

  #TODO: add translation table support
  def base_product
    product_num
  end

  # Returns the list price for a particular calendar month.  opts takes a :year and :month keys, and the list price
  # is calculated for that calendar month based on start & end dates of the line item and contract.
  def list_price_for_month(opts)
    month = opts[:month]
    year = opts[:year]
    days_in_month = Time.days_in_month(month,year)

    if start_date.month == month && start_date.year == year
      #beginning month
      start_day = start_date.day
    elsif (start_date.month > month && start_date.year == year) || (start_date.year > year)
      # month before start_date (have to check for the year too because of wraparound)
      start_day = days_in_month + 1
    else
      start_day = 1
    end

    if end_date.month == month && end_date.year == year
      #ending month
      end_day = end_date.day
    elsif (end_date.month < month && end_date.year == year) || (end_date.year < year)
      # month after end_date (have to check for the year too because of wraparound)
      end_day = 0
    else
      end_day = days_in_month
    end

    days_covered = (end_day - start_day) + 1
    list_price.to_f * (days_covered.to_f / days_in_month.to_f) * qty.to_f
  end

  def self.for_customer(account_id)
    self.find(:all, :joins => :support_deal, :conditions => ["support_deals.account_id = ?", account_id])
  end
end

