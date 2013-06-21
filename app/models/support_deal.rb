# A SupportDeal is an object that store billing information, support levels,
# customer information, etc. for a specific collection of LineItem objects.
#
# Normally this is accessed through one of its child classes - Contract or
# Quote.
# ===Schema
#   id                    integer
#   account_id            string
#   account_name          string
#   sales_office_name     string
#   support_office_name   string
#   said                  string
#   sdc_ref               string
#   description           string
#   sales_rep_id          integer
#   sales_office          string
#   support_office        string
#   cust_po_num           string
#   payment_terms         string
#   platform              string
#   revenue               decimal
#   annual_hw_rev         decimal
#   annual_sw_rev         decimal
#   annual_ce_rev         decimal
#   annual_sa_rev         decimal
#   annual_dr_rev         decimal
#   start_date            date
#   end_date              date
#   multiyr_end           date
#   expired               boolean
#   hw_support_level_id   string
#   sw_support_level_id   string
#   updates               string
#   ce_days               integer
#   sa_days               integer
#   discount_pref_hw      decimal
#   discount_pref_sw      decimal
#   discount_pref_srv     decimal
#   discount_prepay       decimal
#   discount_multiyear    decimal
#   discount_ce_day       decimal
#   discount_sa_day       decimal
#   replacement_sdc_ref   string
#   created_at            datetime
#   updated_at            datetime
#   contract_type         string
#   so_number             string
#   po_number             string
#   renewal_sent          date
#   po_received           date
#   renewal_amount        decimal
#   address1              string
#   address2              string
#   address3              string
#   contact_name          string
#   contact_phone         string
#   contact_email         string
#   contact_note          string
#   basic_remote_monitoring string
#   basic_backup_auditing string
#   primary_ce_id         integer
class SupportDeal < ActiveRecord::Base
  require "parsedate.rb"
  include ParseDate
  include ContractConstants
  has_many :line_items, :dependent => :destroy

  has_many  :succeeds,
            :foreign_key => :successor_id,
            :class_name => 'Relationship',
            :dependent => :destroy
  has_many  :precedes,
            :foreign_key => :predecessor_id,
            :class_name => 'Relationship',
            :dependent => :destroy

  has_many :successors, :through => :precedes
  has_many :predecessors, :through => :succeeds

  has_many :comments, :as => :commentable

  belongs_to :sugar_acct, :foreign_key => :account_id
  belongs_to :end_user, :foreign_key => :end_user_id, :class_name => 'SugarAcct'

  has_one :upfront_order, :dependent => :nullify

  belongs_to :sales_rep, :class_name => 'User'
  belongs_to :primary_ce, :class_name => 'User'

  #Validate General Details
  validates_presence_of :account_id, :account_name, :sales_office, :support_office, :sales_rep_id
  validates_presence_of :said, :sdc_ref #, :platform
  #Validate Terms
  validates_presence_of :start_date, :end_date
  validates_presence_of :hw_support_level_id, :sw_support_level_id

  after_save :update_account_name_from_sugar

  attr_accessor :sn_approximated

  #Named Scopes
  named_scope :unexpired, :conditions => "expired <> 1"
  named_scope :current, :conditions => ["start_date <= ? AND end_date >= ?", Date.today, Date.today]
  named_scope :current_unexpired, :conditions => ["start_date <= ? AND end_date >= ? AND expired <> 1", Date.today, Date.today]

  # This allows iterating through each of the types.
  def srv_support_level_id
    if srv_line_items.inject(0) {|sum,n| sum + n.qty}
      "Services"
    else
      ""
    end
  end

  # accepts an array of team ids, and returns contracts where support_office or
  # sales_office matches the passed array of ids.
  def self.short_list(teams)
    self.find(:all, :select => "sales_rep_id, account_id, id, sales_office_name, support_office_name, said, description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name, expired", :conditions => ["(sales_office IN (?) OR support_office IN(?)) AND (expired <> true OR end_date >= '#{Date.today}')", teams, teams], :order => 'sales_office, account_name, start_date', :group => 'id')
  end

  # Returns Contracts where Contracts.LineItem.serial_num matches serial_num
  def self.serial_search(serial_num, include_expired = false)
		return [] if serial_num.strip == ''
    serial_num.upcase!
    #TODO: Use passed parameters to determine if expired are shown.
    if include_expired
      conditions_array = ['UPPER(line_items.serial_num) = ?', serial_num]
    else
      conditions_array = ['(end_date >= ? OR expired <> 1) AND UPPER(line_items.serial_num) = ?', Date.today, serial_num]
    end
    contracts = self.find(:all, :select => "DISTINCT support_deals.id, sales_office_name, support_office_name, said, support_deals.description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name, expired",
      :joins => :line_items,
			:conditions => conditions_array)
    if contracts.size == 0
      possible_serial_nums = self.find_substituted_sn_chars(serial_num)
      if include_expired
        conditions_array = ['UPPER(line_items.serial_num) IN (?) AND UPPER(line_items.serial_num) IS NOT NULL', possible_serial_nums]
      else
        conditions_array = ['(end_date >= ? OR expired <> 1) AND UPPER(line_items.serial_num) IN (?) AND UPPER(line_items.serial_num) IS NOT NULL', Date.today, possible_serial_nums]
      end

      contracts = self.find(:all, :select => "DISTINCT support_deals.id, sales_office_name, support_office_name, said, support_deals.description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name, expired",
        :joins => :line_items,
        :conditions => conditions_array)
      contracts[0].sn_approximated = true if contracts.size>0
    end
    if contracts.size == 0
      possible_serial_nums = self.insert_missing_sn_chars(serial_num)
      contracts = self.find(:all, :select => "DISTINCT support_deals.id, sales_office_name, support_office_name, said, support_deals.description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name, expired",
        :joins => :line_items,
        :conditions => ['(end_date >= ? OR expired <> 1) AND UPPER(line_items.serial_num) IN (?) AND UPPER(line_items.serial_num) IS NOT NULL', Date.today, possible_serial_nums])
      contracts[0].sn_approximated = true if contracts.size>0
    end
    contracts
  end

  # Returns any SupportDeal with end_date in the next *120* days (in spite of
  # the name) unless Contract.expired = 1.  This is to provide a list of the
  # upcoming unrenewed Contracts
  #--
  # TODO: Move to Contract.
  def self.renewals_next_90_days(teams, ref_date)
    if ref_date.nil?
      ref_date = Date.today
    else
      ref_date = ParseDate.parsedate(ref_date)
      ref_date = Date.new(ref_date[0], ref_date[1], ref_date[2])
    end

    plus90 = ref_date.months_since(4)
    self.find(:all,
      :select => "id, account_id, sales_rep_id, sales_office_name, description, start_date, end_date, (annual_hw_rev + annual_sw_rev + annual_ce_rev + annual_sa_rev + annual_dr_rev) as revenue, account_name, DATEDIFF(end_date, '#{ref_date}') as days_due, renewal_sent, renewal_amount, renewal_created",
      :conditions => ["end_date <= '#{plus90}' AND expired <> 1 AND (sales_office IN (?) OR support_office IN (?))", teams, teams],
      :include => :sales_rep,
      :order => 'sales_office, days_due')
    end

  # Total Annual Revenue - adds +annual_hw_rev+, +annual_sw_rev+, and
  # +annual_srv_rev+
  def total_revenue
    @total_revenue = BigDecimal('0.0')
    if annual_hw_rev.class == BigDecimal
      @total_revenue += annual_hw_rev
    else
      @total_revenue += BigDecimal.new(annual_hw_rev.to_s)
    end
    if annual_sw_rev.class == BigDecimal
      @total_revenue += annual_sw_rev
    else
      @total_revenue += BigDecimal.new(annual_sw_rev.to_s)
    end
    @total_revenue += annual_srv_rev
    @total_revenue
  end

  # Sum of +annual_ce_rev+, +annual_sa_rev+, and +annual_dr_rev+.
  def annual_srv_rev
    @annual_srv_rev = BigDecimal('0.0')
    if annual_ce_rev.class == BigDecimal
      @annual_srv_rev += annual_ce_rev
    else
      @annual_srv_rev += BigDecimal.new(annual_ce_rev.to_s)
    end
    if annual_sa_rev.class == BigDecimal
      @annual_srv_rev += annual_sa_rev
    else
      @annual_srv_rev += BigDecimal.new(annual_sa_rev.to_s)
    end
    if annual_dr_rev.class == BigDecimal
      @annual_srv_rev += annual_dr_rev
    else
      @annual_srv_rev += BigDecimal.new(annual_dr_rev.to_s)
    end
    @annual_srv_rev
  end

  # Returns string "Renewal" if the Contract has a predecessor, otherwise returns
  # 'Newbusiness'.  This is for some reports.
  def status
    if self.renewal?
      'Renewal'
    else
      'Newbusiness'
    end
  end

  # Returns true if the Contract has predecessor(s), otherwise false
  def renewal?
    self.predecessor_ids.size > 0
  end

  # Pulls just the revenue fields (for reports).  Without the date parameter, it
  # returns totals regardless of start and end dates.  An optional date
  # parameter will return historical revenue amounts for that date, which
  # ignores the expired field, only looking at start & end dates.  This is used
  # in the main dashboard revenue report.
  def self.all_revenue(date = nil)
    if date.nil?
      self.find(:first,
        :select => 'sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total_revenue, sum(annual_hw_rev) as annual_hw_rev, sum(annual_sw_rev) as annual_sw_rev, sum(annual_sa_rev) as annual_sa_rev, sum(annual_ce_rev) as annual_ce_rev, sum(annual_dr_rev) as annual_dr_rev',
        :conditions => "expired <> true")
    else
      self.find(:first,
        :select => 'sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total_revenue, sum(annual_hw_rev) as annual_hw_rev, sum(annual_sw_rev) as annual_sw_rev, sum(annual_sa_rev) as annual_sa_rev, sum(annual_ce_rev) as annual_ce_rev, sum(annual_dr_rev) as annual_dr_rev',
        :conditions => ["start_date <= ? AND end_date >= ?", date, date])
    end
  end

  # Returns a hash with the office name as the key, and the number of active
  # contracts as the value.
  def self.contract_counts_by_office
    offices = self.find(:all, :select => 'DISTINCT sales_office_name', :conditions => 'expired <> true', :order => 'sales_office_name')
    hash = {}
    offices.length.times do |x|
      hash[offices[x].sales_office_name] = {'hw' => 0, 'sw' => 0, 'sa' => 0, 'ce' => 0, 'dr' => 0, 'total' => 0 }
    end
    hw = self.count(:account_name, {:conditions => "annual_hw_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    sw = self.count(:account_name, {:conditions => "annual_sw_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    sa = self.count(:account_name, {:conditions => "annual_sa_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    ce = self.count(:account_name, {:conditions => "annual_ce_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    dr = self.count(:account_name, {:conditions => "annual_dr_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    total = self.count(:account_name, {:conditions => "expired <> 1", :group => 'sales_office_name'})

    offices.each do |x|
      hash[x.sales_office_name]['hw'] = hw[x.sales_office_name] ||= 0
      hash[x.sales_office_name]['sw'] = sw[x.sales_office_name] ||= 0
      hash[x.sales_office_name]['sa'] = sa[x.sales_office_name] ||= 0
      hash[x.sales_office_name]['ce'] = ce[x.sales_office_name] ||= 0
      hash[x.sales_office_name]['dr'] = dr[x.sales_office_name] ||= 0
      hash[x.sales_office_name]['total'] = total[x.sales_office_name] ||= 0
    end
    hash
  end

  # Returns a hash with the office name as the key, and the number of active
  # customers as the value.
  def self.customer_counts_by_office
    offices = self.find(:all, :select => 'DISTINCT sales_office_name', :conditions => 'expired <> 1', :order => 'sales_office_name')
    hash = {}
    offices.length.times do |x|
      hash[offices[x].sales_office_name] = {'hw' => 0, 'sw' => 0, 'sa' => 0, 'ce' => 0, 'dr' => 0, 'total' => 0 }
    end
    hw = self.count(:account_name, {:distinct => true, :conditions => "annual_hw_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    sw = self.count(:account_name, {:distinct => true, :conditions => "annual_sw_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    sa = self.count(:account_name, {:distinct => true, :conditions => "annual_sa_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    ce = self.count(:account_name, {:distinct => true, :conditions => "annual_ce_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    dr = self.count(:account_name, {:distinct => true, :conditions => "annual_dr_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    total = self.count(:account_name, {:distinct => true, :conditions => "expired <> 1", :group => 'sales_office_name'})

    offices.each do |x|
      hash[x.sales_office_name]['hw'] = hw[x.sales_office_name] ||= 0
      hash[x.sales_office_name]['sw'] = sw[x.sales_office_name] ||= 0
      hash[x.sales_office_name]['sa'] = sa[x.sales_office_name] ||= 0
      hash[x.sales_office_name]['ce'] = ce[x.sales_office_name] ||= 0
      hash[x.sales_office_name]['dr'] = dr[x.sales_office_name] ||= 0
      hash[x.sales_office_name]['total'] = total[x.sales_office_name] ||= 0
    end
    hash
  end

  # TODO: Move to Contract - should not be needed for quotes.
  # Returns an array of SupportDeal objects, but with the following fields:
  # * sales_office_name (this is the group by field)
  # * total (all annual revenue fields)
  # * hw (annual_hw_revenue)
  # * sw (annual_hw_revenue)
  # * sa (annual_sa_revenue)
  # * ce (annual_ce_revenue)
  # * dr (annual_dr_revenue)
  # Each of the fields is the sum total of all current contracts in that
  # sales_office.
  #
  # Takes an optional +date+. When present, it gives the revenues as of that
  # date. When absent, it gives the revenues of contracts where expired = 0.
  def self.revenue_by_office_by_type(date = nil)
    if date.nil?
      self.find(:all,
        :select => 'sales_office_name, sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total, sum(annual_hw_rev) as hw, sum(annual_sw_rev) as sw, sum(annual_sa_rev) as sa, sum(annual_ce_rev) as ce, sum(annual_dr_rev) as dr',
        :conditions => 'expired <> true',
        :group => 'sales_office_name')
    else
      self.find(:all,
        :select => 'sales_office_name, sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total, sum(annual_hw_rev) as hw, sum(annual_sw_rev) as sw, sum(annual_sa_rev) as sa, sum(annual_ce_rev) as ce, sum(annual_dr_rev) as dr',
        :conditions => ["start_date <= ? AND end_date >= ?", date, date],
        :group => 'sales_office_name')
    end
  end

  #TODO: Make a view for this, or make the current view work with both.
  # Returns an array of SupportDeal objects, with the following fields:
  # * account_name (group field #1)
  # * sales_office_name (group field #2)
  # * total (total of all annual revenue fields)
	def self.customer_rev_list_by_sales_office
		self.find(:all, :select => 'account_name, sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total, sales_office_name', :conditions => 'expired <> true OR (start_date <= DATE(Now()) AND end_date > DATE(Now() ) )', :group => 'account_name, sales_office_name')
	end

  # Takes an array +teams+ that limits the query to only SupportDeal objects
  # having a +support_office+ matching one of the +teams+.
  #
  # Returns an array of SupportDeal objects, with the following fields:
  # * account_name (group field #1)
  # * support_office_name (group field #2)
  # * revenue (total of all annual revenue fields)
  # Sorted by highest +revenue+ first.
	def self.customer_rev_list_by_support_office(teams)
		self.find(:all,
      :select => 'account_name, sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as revenue, support_office_name',
      :conditions => ['support_office IN (?) AND (expired <> true OR (start_date <= DATE(Now()) AND end_date > DATE(Now() ) ))', teams],
      :group => 'account_name, support_office_name',
      :order => 'revenue DESC')
	end

  # Calculates the current effective overall hardware discount of a Contract.
  # Returns a BigDecimal giving the discount as a decimal number, e.g. 30% = 0.3
  def effective_hw_discount
    total_list = BigDecimal.new('0.0')
    self.line_items.each do |x|
      if x.support_type == 'HW'
        x.ext_list_price
        total_list += x.ext_list_price
      end
    end
    BigDecimal.new('1.0') - (self.annual_hw_rev / (total_list * BigDecimal.new('12.0')))
  end

  # Calculates the current effective overall software discount of a Contract
  # Returns a BigDecimal giving the discount as a decimal number, e.g. 30% = 0.3
  def effective_sw_discount
    total_list = BigDecimal.new('0.0')
    self.line_items.each do |x|
      if x.support_type == 'SW'
        x.ext_list_price
        total_list += x.ext_list_price
      end
    end
    BigDecimal.new('1.0') - (self.annual_sw_rev / (total_list * BigDecimal.new('12.0')))
  end

  # Calculates the current effective overall services discount of a Contract
  # Returns a BigDecimal giving the discount as a decimal number, e.g. 30% = 0.3
  def effective_srv_discount
    total_list = BigDecimal.new('0.0')
    self.line_items.each do |x|
      if x.support_type == 'SRV'
        x.ext_list_price
        total_list += x.ext_list_price
      end
    end
    BigDecimal.new('1.0') - (self.annual_srv_rev / (total_list * BigDecimal.new('12.0')))
  end

  # Returns a String: po_received date translated to YYYYM.
  # Useful for in-place filtering based on date
  def period
    month = self.po_received.month
    self.po_received.year.to_s + month.to_s
  end

  # Determines an expected renewal amount, taking into account the
  # +renewal_amount+ field.  If the field is blank, it estimates based on the
  # current list prices.
  #
  # Returns a Float.
  def expected_revenue
    if !renewal_amount.nil?
      @x = renewal_amount
    elsif payment_terms != "Bundled"
      hw_t = 0.0
      line_items.each {|l| hw_t += (l.current_list_price.nil? ? 0.0 : l.current_list_price * (l.qty.nil? ? 0.0 : l.qty)) if l.support_type == "HW" }
      hw_t = hw_t * (1.0 - (discount_pref_hw + (payment_terms == "Annual" ? discount_prepay : 0.0)))

      sw_t = 0.0
      line_items.each {|l| sw_t += (l.current_list_price.nil? ? 0.0 : l.current_list_price * (l.qty.nil? ? 0.0 : l.qty)) if l.support_type == "SW" }
      sw_t = sw_t * (1.0 - (discount_pref_sw + (payment_terms == "Annual" ? discount_prepay : 0.0)))

      srv_t = 0.0
      line_items.each {|l| srv_t += (l.list_price.nil? ? 0.0 : l.list_price * (l.qty.nil? ? 0.0 : l.qty)) if l.support_type == "SRV" }
      srv_t = srv_t * (1.0 - (discount_pref_srv + (payment_terms == "Annual" ? discount_prepay : 0.0)))

      @x = 12 * ((hw_t * hw_support_level_multiplier) + (sw_t * sw_support_level_multiplier) + srv_t)

    else
      t = 0.0
      line_items.each {|l| t += (l.current_list_price.nil? ? 0.0 : l.current_list_price * (l.qty.nil? ? 0.0 : l.qty)) }
      @x = t * 12 * 0.5
    end
  end

  # Returns a BigDecimal used as a price multiplier for the various levels of
  # hardware support. Example:
  #   c = SupportDeal.new(:hw_support_level_id => "SDC ND") => {:id=>37, :hw_support_level_id=>"SDC ND"}
  #   c.save
  #   c.hw_support_level_multiplier # 0.65
  def hw_support_level_multiplier
    case hw_support_level_id
      when "SDC 24x7" then 1
      when "SDC SD" then BigDecimal.new('0.83')
      when "SDC ND" then BigDecimal.new('0.65')
      when "SDC CS" then BigDecimal.new('1.65')
      else 1
    end
  end

  # returns a BigDecimal used as a price multiplier for the various levels of
  # software support. See +hw_support_level_multiplier+.
  def sw_support_level_multiplier
    case sw_support_level_id
      when "SDC SW 24x7" then 1
      when "SDC SW 13x5" then BigDecimal.new('0.83')
      else 1
    end
  end

  # TODO: Fix so that we are not using the inaccurate +effective_*_discount+
  # methods.
  #
  # Updates the effective_price attribute for each of the line items in a contract.
  def update_line_item_effective_prices
    logger.debug "********** Contract update_line_item_effective_prices"
    hw_disc = BigDecimal.new('1.0') - self.effective_hw_discount
    sw_disc = BigDecimal.new('1.0') - self.effective_sw_discount
    srv_disc = BigDecimal.new('1.0') - self.effective_srv_discount
    self.line_items.each do |lineitem|
      if lineitem.list_price.nil? || lineitem.list_price == BigDecimal.new('0.0')
        lineitem.list_price, lineitem.effective_price = 0.0, 0.0
      else
        lineitem.effective_price = hw_disc * lineitem.list_price if lineitem.support_type == "HW"
        lineitem.effective_price = sw_disc * lineitem.list_price if lineitem.support_type == "SW"
        lineitem.effective_price = srv_disc * lineitem.list_price if lineitem.support_type == "SRV"
      end
      lineitem.save
    end
  end

  # Returns a collection of Contract objects which meet the following conditions:
  # * They contain line items that have a support provider != 'Sourcedirect'
  # * They are current
  # * Some of the line items that have a support provider != 'Sourcedirect' also
  #   have subcontractor_id == nil
  def self.missing_subcontracts
    support_deal_ids = LineItem.find(:all, :select => "support_deal_id", :conditions => "support_provider <> 'Sourcedirect' AND subcontract_id IS NULL").map {|l| l.support_deal_id}.uniq
    @support_deals = self.current_unexpired.find(:all, :conditions => ["id IN (?)", support_deal_ids])
    @support_deals
  end

  # Returns the last +num+ comments for a SupportDeal. If num is not provided,
  # or is equal to 1, returns a single comment object, otherwise returns an
  # array of comments.
  # If there are no comments, returns +nil+.
  def last_comment(num = 1)
    if num == 1
      Comment.find(:first, :conditions => ["commentable_id = ? AND commentable_type IN ('SupportDeal', 'Contract')", self.id], :order => "id DESC")
    else
      Comment.find(:all, :conditions => ["commentable_id = ? AND commentable_type IN ('SupportDeal', 'Contract')", self.id], :order => "id DESC", :limit => num )
    end
  end

  # BEGIN New methods for quoting #

  # returns a float corresponding to the number of months the contract is valid.
  def effective_months
    y = (end_date.year - start_date.year) * 12
    m = (end_date.mon - start_date.mon)
    last_month_days = ((end_date.day - end_date.beginning_of_month.day) + 1).to_f / end_date.end_of_month.day
    first_month_days = ((start_date.end_of_month.day - start_date.day) + 1).to_f / start_date.end_of_month.day
    first_and_last = start_date.day - 1 == end_date.day ? 1 : last_month_days + first_month_days
    (y + m + first_and_last) - 1
  end

  # Returns an Array of the hardware +line_items+.
  def hw_line_items
    #line_items.find_all {|l| l.support_type == "HW"}.sort_by {|n| n.position}
    line_items.find_all_by_support_type("HW", :order => 'position ASC')
  end

  # Returns an Array of the software +line_items+.
  def sw_line_items
    #line_items.find_all {|l| l.support_type == "SW"}.sort_by {|n| n.position}
    line_items.find_all_by_support_type("SW", :order => 'position ASC')
  end

  # Returns an Array of the services +line_items+.
  def srv_line_items
    #line_items.find_all {|l| l.support_type == "SRV"}.sort_by {|n| n.position}
    line_items.find_all_by_support_type("SRV", :order => 'position ASC')
  end

  # Returns a Float - hardware list price based on the +line_items+.
  def hw_list_price
    hw_line_items.inject(0) {|sum, n| sum + (n.list_price.to_f * n.effective_months * n.qty.to_i).to_f}
  end

  # Returns a Float - software list price based on the +line_items+.
  def sw_list_price
    sw_line_items.inject(0) {|sum, n| sum + (n.list_price.to_f * n.effective_months * n.qty.to_i).to_f}
  end

  # Returns a Float - services list price based on the +line_items+.
  def srv_list_price
    srv_line_items.inject(0) {|sum, n| sum + (n.list_price.to_f * n.effective_months * n.qty.to_i).to_f}
  end

  # Total of +hw_list_price+, +sw_list_price+ and +srv_list_price+
  def total_list_price
    hw_list_price + sw_list_price + srv_list_price
  end

  # like hw_line_items, but uses the DB to pre-group the items by date.
  # this is to optimize the payment_schedule method
  def hw_line_items_for_payment_schedule
    line_items.find(:all,
      :select => '1 as qty, SUM(COALESCE(qty,0) * COALESCE(list_price,0.0)) AS list_price, begins, ends, support_deal_id',
      :group => 'support_deal_id, begins, ends',
      :conditions => 'support_type = "HW"')
  end
  # like sw_line_items, but uses the DB to pre-group the items by date.
  # this is to optimize the payment_schedule method
  def sw_line_items_for_payment_schedule
    line_items.find(:all,
      :select => '1 as qty, SUM(COALESCE(qty,0) * COALESCE(list_price,0.0)) AS list_price, begins, ends, support_deal_id',
      :group => 'support_deal_id, begins, ends',
      :conditions => 'support_type = "SW"')
  end
  # like srv_line_items, but uses the DB to pre-group the items by date.
  # this is to optimize the payment_schedule method
  def srv_line_items_for_payment_schedule
    line_items.find(:all,
      :select => '1 as qty, SUM(COALESCE(qty,0) * COALESCE(list_price,0.0)) AS list_price, begins, ends, support_deal_id',
      :group => 'support_deal_id, begins, ends',
      :conditions => 'support_type = "SRV"')
  end

  #Efficient query to determine cost of all associated subcontracts.  Returns a NEGATIVE number!
  def subcontract_cost
    subcontract_ids = line_items.find(:all,
      :select => 'DISTINCT subcontract_id AS ids').map {|x| x.ids}
    logger.debug subcontract_ids.inspect
    if subcontract_ids == [nil]
      @subcontract_cost = BigDecimal.new("0.0")
    else
      @subcontract_cost = - Subcontract.find(subcontract_ids).sum {|subk| subk.nil? ? BigDecimal.new("0.0") : BigDecimal.new(subk.cost.to_s)}
    end
    @subcontract_cost
  end



  # Returns a BigDecimal of the discount percentage (e.g. 30% => 0.30)
  #
  # +opts+ hash
  #   :type => ['hw', 'sw', 'srv']
  #   :prepay => [true, false]
  #   :multiyear => [true, false]
  def discount(opts={:type => 'hw', :prepay => false, :multiyear => false})
    type = opts[:type].to_s
    @discount = send("discount_pref_#{type}")
    @discount += discount_prepay if opts[:prepay]
    @discount += discount_multiyear if opts[:multiyear]
    @discount
  end

  # Returns a BigDecimal of the discount amount (how much the discount percentage
  # subtracts from the total)
  #
  # +opts+ hash
  #   :type => ['hw', 'sw', 'srv']
  #   :prepay => [true, false]
  #   :multiyear => [true, false]
  def discount_amount(opts={:type => 'hw', :prepay => false, :multiyear => false})
    discount(opts) * send("#{opts[:type].to_s}_list_price")
  end

  # Returns a BigDecimal of the hardware discount amount (e.g. 30% => 0.30)
  def hw_disc_amt
    hw_list_price * discount_pref_hw
  end

  # Returns a BigDecimal of the software discount amount (e.g. 30% => 0.30)
  def sw_disc_amt
    sw_list_price * discount_pref_sw
  end

  # Returns a BigDecimal of the services discount amount (e.g. 30% => 0.30)
  def srv_disc_amt
    srv_list_price * discount_pref_srv
  end

  # Returns the number of calendar months covered by the contract.
  # Example:
  #   a = Contract.new(:start_date => Date.parse('2009-01-01'), :end_date => Date.parse('2009-12-31'))
  #   b = Contract.new(:start_date => Date.parse('2009-01-31'), :end_date => Date.parse('2009-02-01'))
  #   a.save;b.save
  #   a.calendar_months # 12
  #   b.calendar_months # 2
  def calendar_months
    (end_date.mon - start_date.mon) + ((end_date.year - start_date.year) * 12) + 1
  end

  # DEPRECATED - original version of payment_schedule.  Was too slow.
  # Returns an array of payment amounts for a contract (useful for a payment
  # schedule).  Uses calendar months -- any days in a specific month will
  # generate an array member with the calculated price for that month.  The
  # length of this array is thus +calendar_months+
  def payment_schedule_old(opts={})
    opts.reverse_merge! :multiyear=> false, :prepay => false, :start_date => self.start_date, :end_date => self.end_date

    prepay = opts[:prepay]
    multiyear = opts[:multiyear]
    month = opts[:start_date].month
    year = opts[:start_date].year
    end_month = opts[:end_date].month
    end_year = opts[:end_date].year

    hw_pay_sched = []
    sw_pay_sched = []
    srv_pay_sched = []
    @payment_schedule = []
    # set discount
    hw_disc = BigDecimal.new("1.0") - discount(:type => "hw", :prepay => prepay, :multiyear => multiyear)
    sw_disc = BigDecimal.new("1.0") - discount(:type => "sw", :prepay => prepay, :multiyear => multiyear)
    srv_disc = BigDecimal.new("1.0") - discount(:type => "srv", :prepay => prepay, :multiyear => multiyear)

    until (year > end_year && month == 1) || (month > end_month && year == end_year) do
      #logger.debug "month start " + Time.now.to_f.to_s
      #hw_pay_sched << hw_line_items.inject(0) {|sum, n| sum + n.list_price_for_month(:year => year, :month => month) * hw_disc}
      sum = BigDecimal('0')
      hw_line_items.each {|n| sum += n.list_price_for_month(:year => year, :month => month) * hw_disc}
      hw_pay_sched << sum
      #sw_pay_sched << sw_line_items.inject(0) {|sum, n| sum + n.list_price_for_month(:year => year, :month => month) * sw_disc}
      sum = BigDecimal('0')
      sw_line_items.each {|n| sum += n.list_price_for_month(:year => year, :month => month) * sw_disc}
      sw_pay_sched << sum
      #srv_pay_sched << srv_line_items.inject(0) {|sum, n| sum + n.list_price_for_month(:year => year, :month => month) * srv_disc}
      sum = BigDecimal('0')
      srv_line_items.each {|n| sum += n.list_price_for_month(:year => year, :month => month) * srv_disc}
      srv_pay_sched << sum

      year += 1 if month == 12
      month = 0 if month == 12
      month += 1
      #logger.debug "month done " + Time.now.to_f.to_s
    end

    hw_pay_sched.size.times do |i|
      @payment_schedule << hw_pay_sched[i] + sw_pay_sched[i] + srv_pay_sched[i]
    end
    @payment_schedule
  end

  def payment_schedule_beta(opts={})
    opts.reverse_merge! :multiyear=> false, :prepay => false, :start_date => self.start_date, :end_date => self.end_date
    if payment_terms == "Annual" || payment_terms == "Monthly"
      payment_schedule_for_normal(opts)
    elsif bundled?
      payment_schedule_for_bundled(opts)
    elsif twomonthsfree?
      payment_schedule_for_twomonthsfree(opts)
    else
      payment_schedule_for_normal(opts)
    end
  end
  def payment_schedule(opts={})
    #puts 'payment_schedule opts:'
    #p opts
    opts.reverse_merge! :multiyear=> multiyear?, :prepay => prepay?, :start_date => start_date, :end_date => end_date

    #p opts
    prepay = opts[:prepay]
    multiyear = opts[:multiyear]
    month = opts[:start_date].month
    year = opts[:start_date].year
    end_month = opts[:end_date].month
    end_year = opts[:end_date].year

    hw_pay_sched = []
    sw_pay_sched = []
    srv_pay_sched = []
    @payment_schedule = []
    # set discount
    hw_disc = BigDecimal.new("1.0") - discount(:type => "hw", :prepay => prepay, :multiyear => multiyear)
    sw_disc = BigDecimal.new("1.0") - discount(:type => "sw", :prepay => prepay, :multiyear => multiyear)
    srv_disc = BigDecimal.new("1.0") - discount(:type => "srv", :prepay => prepay, :multiyear => multiyear)

    until (year > end_year && month == 1) || (month > end_month && year == end_year) do
      #logger.debug "month start " + Time.now.to_f.to_s
      sum = BigDecimal('0')
      hw_line_items_for_payment_schedule.each {|n| sum += n.list_price_for_month(:year => year, :month => month) * hw_disc}
      hw_pay_sched << sum
      sum = BigDecimal('0')
      sw_line_items_for_payment_schedule.each {|n| sum += n.list_price_for_month(:year => year, :month => month) * sw_disc}
      sw_pay_sched << sum
      sum = BigDecimal('0')
      srv_line_items_for_payment_schedule.each {|n| sum += n.list_price_for_month(:year => year, :month => month) * srv_disc}
      srv_pay_sched << sum

      year += 1 if month == 12
      month = 0 if month == 12
      month += 1
      #logger.debug "month done " + Time.now.to_f.to_s
    end

    hw_pay_sched.size.times do |i|
      @payment_schedule << hw_pay_sched[i] + sw_pay_sched[i] + srv_pay_sched[i]
    end
    @payment_schedule
  end

  # END New methods for quoting #

  def multiyear?
    payment_terms.split("+")[1] == 'MY'
  end

  def prepay?
    payment_terms.split("+")[0] == 'Annual'
  end

  def bundled?
    payment_terms == 'Bundled'
  end

  def twomonthsfree?
    if !bundled? &&
        calendar_months > 13 && calendar_months < 16 &&
        (total_revenue / payment_schedule(:multiyear => multiyear?, :prepay => prepay?).sum).round(3) == (BigDecimal.new('12.0') / BigDecimal.new('14.0')).round(3)
      return true
    else
      return false
    end
  end

  def unearned_revenue_schedule_array(opts={})
    opts.reverse_merge! :start_date => start_date, :end_date => end_date
    #debugger

    #opts[:start_date] = Date.parse(opts[:start_date]) unless opts[:start_date].class == Date
    #opts[:end_date] = Date.parse(opts[:end_date]) unless opts[:end_date].class == Date
    if bundled?
      ps_array = unearned_revenue_schedule_array_for_bundled(:start_date => opts[:start_date], :end_date => opts[:end_date])
    elsif twomonthsfree?
      ps_array = unearned_revenue_schedule_array_for_twomonthsfree(:multiyear => multiyear?, :prepay => prepay?, :start_date => opts[:start_date], :end_date => opts[:end_date])
    else #payment_terms.split('+')[0] == "Annual" || payment_terms.split('+')[0] == "Monthly"
      ps_array = payment_schedule(:multiyear => multiyear?, :prepay => prepay?, :start_date => opts[:start_date], :end_date => opts[:end_date])
    end
    ps_array
  end

  def unearned_revenue
    unearned_revenue_schedule_array.sum
  end

  def self.payment_schedule_headers(opts={})
    payment_schedule_headers = []
    opts[:start_date].class == Date ? date = opts[:start_date] : date = Date.parse(opts[:start_date])
    opts[:end_date].class == Date ? end_date = opts[:end_date] : end_date = Date.parse(opts[:end_date])
    date = Date.new(date.year, date.month, 1)
    while date <= end_date
      payment_schedule_headers << date
      date = date.next_month
    end
    return payment_schedule_headers
  end

  def unearned_revenue_schedule_array_for_twomonthsfree(opts = {})
    opts.reverse_merge! :start_date => start_date, :end_date => end_date
    ps_array = payment_schedule(:multiyear => multiyear?, :prepay => prepay?, :start_date => opts[:start_date], :end_date => opts[:end_date])
    ps_array.collect! {|x| x * BigDecimal.new("12")/BigDecimal.new("14")}
    ps_array
  end

  def unearned_revenue_schedule_array_for_bundled(opts = {})
    monthly_revenue = total_revenue / 12

    opts.reverse_merge! :multiyear=> false, :prepay => false, :start_date => self.start_date, :end_date => self.end_date

    month = opts[:start_date].month
    year = opts[:start_date].year
    end_month = opts[:end_date].month
    end_year = opts[:end_date].year

    @payment_schedule = []

    until (year > end_year && month == 1) || (month > end_month && year == end_year) do
      #FIGURE PRICE
      #this month is before the start date or after the end date
      if (start_date.month > month && start_date.year == year) || (start_date.year > year)
        @payment_schedule << BigDecimal('0')
      elsif (end_date.month < month && end_date.year == year) || (end_date.year < year)
        @payment_schedule << BigDecimal('0')
      else
        days_in_month = BigDecimal(Time.days_in_month(month,year).to_s)

        if start_date.month == month && start_date.year == year
          #beginning month
          start_day = start_date.day
        else
          start_day = 1
        end

        if end_month == month && end_year == year
          #ending month
          end_day = end_date.day
        else
          end_day = days_in_month
        end

        days_covered = BigDecimal(((end_day - start_day) + 1).to_s)
        @payment_schedule << monthly_revenue * (days_covered / days_in_month)

      end

      # year & month += 1
      year += 1 if month == 12
      month = 0 if month == 12
      month += 1
    end

    @payment_schedule
  end

protected

  # This method updates the account_name field from SugarCRM for all the Contracts with a matching account_id
  def update_account_name_from_sugar
    SupportDeal.update_all(["account_name = ?", sugar_acct && sugar_acct.name ], ["account_id = ?", account_id])
  end

  # Returns an Array of strings giving possible alternate serial numbers based
  # on visual similarity (0 = O; 5 = S, etc.)
  def self.find_substituted_sn_chars(serial_num)
    #check for similar serial numbers
    possible_serial_nums = []
    patterns = [
      ["0","O"],
      ["O","0"],
      ["1","I"],
      ["I","1"],
      ["S","5"],
      ["5","S"],
      ["O","Q"],
      ["Q","O"],
      ["0","Q"],
      ["Q","0"],
      ["B","8"],
      ["8","B"],
      ["U","V"],
      ["V","U"]
      ]
    sn_arr = serial_num.split(//)
    patterns.each do |pattern|
      sn_arr = serial_num.split(//)
      sn_arr.each_with_index do |letter,position|
        sn_arr = serial_num.split(//)
        if letter == pattern[0]
          sn_arr[position] = pattern[1]
          possible_serial_nums << sn_arr.to_s
        end
      end
    end
    logger.debug "POSSIBLE SERIAL NUMBERS: #{possible_serial_nums.inspect}"
    possible_serial_nums
  end

  # Returns an Array of strings giving possible alternate serial numbers
  # generated by adding A-Z and 0-9 between each of the characters in the serial
  # number.  Note that this generates (serial_num.length + 1) * 36 additional
  # serial numbers.
  def self.insert_missing_sn_chars(serial_num)
    #check for missing characters...
    possible_serial_nums = []
    chars = ("A".."Z").to_a + (0..9).to_a
    sn_arr = serial_num.split(//)
    chars.each do |char|
      sn_arr.each_index do |position|
        sn_arr = serial_num.split(//)
        sn_arr.insert(position,char)
        possible_serial_nums << sn_arr.to_s
      end
    end
    logger.debug "POSSIBLE SERIAL NUMBERS: (inserting) #{possible_serial_nums.inspect}"
    possible_serial_nums
  end
end
