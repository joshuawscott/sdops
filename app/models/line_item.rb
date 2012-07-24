# A LineItem is a specific billable line on a SupportDeal.  It can have a zero
# charge.  Normally this is a particular product (hardware or software) or a
# label line to give extra information on the final quote document.
# ===Schema
#   id            integer
#   support_deal_id   integer
#   support_type  string
#   product_num   string
#   serial_num    string
#   description   string
#   begins        date
#   ends          date
#   qty           integer
#   list_price    decimal(20.3)
#   created_at    datetime
#   updated_at    datetime
#   support_provider  string
#   position      integer
#   location      string
#   current_list_price  decimal(20,3)
#   effective_price     decimal(20.3)
#   note          string
#   subcontract_id  integer
#   subcontract_cost  decimal(20,2)
#
class LineItem < ActiveRecord::Base
  @@support_types = ['HW', 'SW', 'SRV']
  belongs_to :support_deal
  belongs_to :contract, :foreign_key => :support_deal_id
  belongs_to :quote, :foreign_key => :support_deal_id
  belongs_to :subcontract
  validates_presence_of :support_type, :in => @@support_types
  validates_presence_of :location, :position, :product_num
  acts_as_audited :except => [:effective_price, :position]
  acts_as_list :scope => :support_deal
  named_scope :in_contracts, :joins => :contract
  named_scope :in_quotes, :joins => :quote

  # Aggregates the locations in LineItems as an Array Object
  def self.locations
    LineItem.find(:all, :select => 'location', :joins => :support_deal, :conditions => ['support_deals.expired = ?', false], :group => 'location').map {|x| x.location.to_s}.sort!
  end

  # Returns a collection of LineItem Objects with the total revenue for each
  # location
  def self.hw_revenue_by_location(effective_time = Time.now)

    locations = LineItem.in_contracts.find(:all, :select => 'line_items.*, SUM(effective_price * qty * 12) AS revenue', :conditions => ["begins <= :time AND ends >= :time AND support_type = 'HW'", {:time => effective_time}], :group => 'location ASC' )
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

  # Returns a HwSupportPrice or SwSupportPrice object, if support_type is 'HW'
  # or 'SW' respectively. If support_type is 'SRV', returns nil.  This method is
  # for updating from the current pricing DB.
  def return_current_info
    @current_info = (support_type.downcase + "_support_price").camelize.constantize.current_list_price(product_num) unless support_type == 'SRV'
    if support_type.downcase == 'hw'
      @current_info.list_price = (@current_info.list_price * (self.support_deal.list_price_increase.to_f + BigDecimal('1.0')) * self.support_deal.hw_support_level_multiplier).round
    end
    if support_type.downcase == 'sw'
      @current_info.list_price = (@current_info.list_price * (self.support_deal.list_price_increase.to_f + BigDecimal('1.0')) * self.support_deal.sw_support_level_multiplier).round
    end
    @current_info
  end

  # Returns an array of support type strings.
  def self.support_types
    @@support_types
  end

  # Unassociates the LineItem from it's parent model.  Takes a class constant
  # and returns true if successful.
  def remove_from(associated_model)
    self.send(associated_model.class.to_s.foreign_key + '=', nil)
    save(false)
  end

  # returns a float corresponding to the number of months that the line item is
  # valid.
  def effective_months
    return 0 if start_date > end_date
    y = (end_date.year - start_date.year) * 12
    m = (end_date.mon - start_date.mon)
    last_month_days = ((end_date.day - end_date.beginning_of_month.day) + 1).to_f / end_date.end_of_month.day
    first_month_days = ((start_date.end_of_month.day - start_date.day) + 1).to_f / start_date.end_of_month.day
    first_and_last = start_date.day - 1 == end_date.day ? 1 : last_month_days + first_month_days
    (y + m + first_and_last) - 1
  end

  # Returns a Date object.  The date is the greater of +begins+ or the parent
  # SupportDeal's +start_date+.
  def start_date
    return begins if support_deal.nil?
    self.begins ||= support_deal.start_date
    return support_deal.start_date > begins ? support_deal.start_date : begins
  end

  # Returns a Date object.  The date is the greater of +ends+ or the parent
  # SupportDeal's +end_date+.
  def end_date
    return ends if support_deal.nil?
    self.ends ||= support_deal.end_date
    return support_deal.end_date < ends ? support_deal.end_date : ends
  end

  # Calculates the spares needed in an office, based on the covered equipment
  def self.sparesreq(office_name)
    @lineitems = LineItem.find(:all,
      :select => 'l.product_num, l.description, sum(l.qty) as count',
      :conditions => ['l.support_provider = "Sourcedirect" AND l.location = ? AND l.support_type = "HW" AND l.product_num <> "LABEL" AND (l.ends > CURDATE() AND l.begins < ADDDATE(CURDATE(), INTERVAL 30 DAY) OR c.expired <> true)', office_name],
      :joins => 'as l inner join support_deals c on c.id = l.support_deal_id AND c.type = "Contract"',
      :group => 'l.product_num')
  end

  # FIXME: Not working with Fishbowl.  Bug #14
  # When fixed, remove the warning from app/views/reports/spares_assessment.html.haml
  # Do not use until fixed.
  def qty_instock(office_name=nil)
=begin
    # Old Appgen Code
    if office_name.nil?
      InventoryItem.count(:conditions => ['item_code = ?', base_product])
    else
      wc = InventoryItem.warehouse_code_for(office_name)
      InventoryItem.count(:conditions => ['item_code = ? AND warehouse = ?', base_product, wc])
    end
=end

    if office_name.nil?
      begin
        FishbowlQoh.find(:all, :params => {:partnum => base_product }).length
      rescue ActiveResource::ResourceNotFound
        0
      end
    else
      begin
        #@fb_locationgroup ||= Rails.cache.fetch("fishbowl_locationgroup_#{locationgroupid}") { Fishbowl.find(:first, :from => :locationgroup, :params => {:id => locationgroupid} ) }
        qbclass ||= Rails.cache.fetch("fishbowl_qbclass_name_#{office_name}") { Fishbowl.find(:first, :from => :qbclass, :params => {:name => office_name, :use_limit => 1} ) }
        locationgroups ||= Rails.cache.fetch("fishbowl_locationgroups_qbclassid_#{qbclass.id}") {Fishbowl.find(:all, :from => :locationgroup, :params => {:qbclassid => qbclass.id}).delete_if { |lg| !lg.name.include? "Spr" } }
        locationgroupids = locationgroups.map { |lg| lg.id }
        FishbowlQoh.find(:all, :params => {:partnum => base_product, :locationgroupid => locationgroupids}).length
      rescue ActiveResource::ResourceNotFound
        0
      end
    end
  end

  # Alias for +product_num+
  #--
  # TODO: add translation table support; base_product should find similar part
  # numbers as well as the actual product number.
  def base_product
    product_num
  end

  # Returns the list price for a particular calendar month.  opts takes a :year
  # and :month keys, and the list price is calculated for that calendar month
  # based on start & end dates of the line item and contract.
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

  # Finds all line items for a customer in contracts. (excludes quotes)
  def self.for_customer(account_id)
    self.find(:all, :joins => :contract, :conditions => ["support_deals.account_id = ?", account_id])
  end

  def contract_ids_by_location
    LineItem.find(:all, :select => 'distinct support_deal_id', :joins => :contract, :conditions => ['location = ?', location]).map{|x| x.support_deal_id}
  end
end
