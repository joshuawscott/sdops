# Schema:
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
#   new_business_dollars  decimal


class Contract < ActiveRecord::Base
  require "parsedate.rb"
  include ParseDate
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

  has_many :commissions, :as => :commissionable

  belongs_to :sugar_acct, :foreign_key => :account_id

  has_one :upfront_order, :dependent => :nullify

  #Validate General Details
  validates_presence_of :account_id, :account_name, :sales_office, :support_office, :sales_rep_id
  validates_presence_of :said, :sdc_ref, :payment_terms, :platform
  #Validate Revenue
  validates_numericality_of :revenue, :annual_hw_rev, :annual_sw_rev, :annual_sa_rev, :annual_ce_rev, :annual_dr_rev
  #Validate Terms
  validates_presence_of :start_date, :end_date, :po_received

  before_save :update_line_item_effective_prices
  after_save :update_account_name_from_sugar

  attr_accessor :sn_approximated

  #Named Scopes
  named_scope :unexpired, :conditions => "expired <> 1"
  named_scope :current, :conditions => ["start_date <= ? AND end_date >= ?", Date.today, Date.today]
  named_scope :current_unexpired, :conditions => ["start_date <= ? AND end_date >= ? AND expired <> 1", Date.today, Date.today]


  # accepts an array of team ids, and returns contracts where support_office or sales_office
  # matches the passed array of ids.
  def self.short_list(teams)
    Contract.find(:all, :select => "id, sales_office_name, support_office_name, said, description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name", :conditions => ["(sales_office IN (?) OR support_office IN(?)) AND expired <> true", teams, teams], :order => 'sales_office, account_name, start_date', :group => 'id')
  end

  # Returns Contracts where Contracts.LineItem.serial_num matches serial_num
  def self.serial_search(serial_num)
		return [] if serial_num.strip == ''
    serial_num.upcase!
    #TODO: Use passed parameters to determine if expired are shown.
    contracts = Contract.find(:all, :select => "DISTINCT contracts.id, sales_office_name, support_office_name, said, contracts.description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name",
      :joins => :line_items,
			:conditions => ['expired <> 1 AND UPPER(line_items.serial_num) = ?', serial_num])
    if contracts.size == 0
      possible_serial_nums = self.find_substituted_sn_chars(serial_num)
      contracts = Contract.find(:all, :select => "DISTINCT contracts.id, sales_office_name, support_office_name, said, contracts.description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name",
        :joins => :line_items,
        :conditions => ['expired <> 1 AND UPPER(line_items.serial_num) IN (?) AND UPPER(line_items.serial_num) IS NOT NULL', possible_serial_nums])
      contracts[0].sn_approximated = true if contracts.size>0
    end
    if contracts.size == 0
      possible_serial_nums = self.insert_missing_sn_chars(serial_num)
      contracts = Contract.find(:all, :select => "DISTINCT contracts.id, sales_office_name, support_office_name, said, contracts.description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name",
        :joins => :line_items,
        :conditions => ['expired <> 1 AND UPPER(line_items.serial_num) IN (?) AND UPPER(line_items.serial_num) IS NOT NULL', possible_serial_nums])
      contracts[0].sn_approximated = true if contracts.size>0
    end
    contracts
  end

  # Returns Contracts with end_date in the next 90 days, unless Contract.expired = 1
  def self.renewals_next_90_days(teams, ref_date)
    if ref_date.nil?
      ref_date = Date.today
    else
      ref_date = ParseDate.parsedate(ref_date)
      ref_date = Date.new(ref_date[0], ref_date[1], ref_date[2])
    end


    plus90 = ref_date.months_since(3)
    Contract.find(:all,
      :select => "id, sales_office_name, description, start_date, end_date, (annual_hw_rev + annual_sw_rev + annual_ce_rev + annual_sa_rev + annual_dr_rev) as revenue, account_name, DATEDIFF(end_date, '#{ref_date}') as days_due, renewal_sent, renewal_amount",
      :conditions => ["end_date <= '#{plus90}' AND expired <> 1 AND (sales_office IN (?) OR support_office IN (?))", teams, teams],
      :order => 'sales_office, days_due')
    end

  # Total Annual Revenue
  def total_revenue
     annual_hw_rev + annual_sw_rev + annual_ce_rev + annual_sa_rev + annual_dr_rev
  end

  def annual_srv_rev
    annual_ce_rev + annual_sa_rev + annual_dr_rev
  end

  #Calculates the amount of New Business for this contract
  def new_business
    if predecessors.size > 0
      @newbusiness = [total_revenue - predecessors.inject(0) {|sum, n| sum + n.total_revenue}, 0].max
    else
      @newbusiness = total_revenue
    end
  end

  #Calculates the amount of business that did not renew
  def self.non_renewing_contracts(startdate, enddate)
    c = Contract.find(:all, :conditions => ["expired = 1 AND end_date >= ? AND end_date <= ?", startdate, enddate])
    nonrenew = c.inject(0) {|sum, n| n.successors.size == 0 ? sum - n.total_revenue : sum }
  end


  #Calculates the amount of change, per contract, bewteen current year and previous year
  def renewal_attrition
    if predecessors.size > 0
      @attrition = total_revenue - predecessors.inject(0) {|sum, n| sum + n.total_revenue}
    else
      @attrition = 0
    end
  end

  # Returns string "Renewal" if the Contract has a predecessor, otherwise returns
  # 'Newbusiness'
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

  # Pulls just the revenue fields (for reports).  Without the date parameter, it returns totals
  # regardless of start and end dates.  An optional date parameter will return historical
  # revenue amounts for that date, which ignores the expired field, only looking at start & end dates.
  def self.all_revenue(date = nil)
    if date.nil?
      Contract.find(:first,
        :select => 'sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total_revenue, sum(annual_hw_rev) as annual_hw_rev, sum(annual_sw_rev) as annual_sw_rev, sum(annual_sa_rev) as annual_sa_rev, sum(annual_ce_rev) as annual_ce_rev, sum(annual_dr_rev) as annual_dr_rev',
        :conditions => "expired <> true")
    else
      Contract.find(:first,
        :select => 'sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total_revenue, sum(annual_hw_rev) as annual_hw_rev, sum(annual_sw_rev) as annual_sw_rev, sum(annual_sa_rev) as annual_sa_rev, sum(annual_ce_rev) as annual_ce_rev, sum(annual_dr_rev) as annual_dr_rev',
        :conditions => ["start_date <= ? AND end_date >= ?", date, date])
    end
  end

  # For Dashboard report
  def self.contract_counts_by_office
    offices = Contract.find(:all, :select => 'DISTINCT sales_office_name', :conditions => 'expired <> true', :order => 'sales_office_name')
    hash = {}
    offices.length.times do |x|
      hash[offices[x].sales_office_name] = {'hw' => 0, 'sw' => 0, 'sa' => 0, 'ce' => 0, 'dr' => 0, 'total' => 0 }
    end
    hw = Contract.count(:account_name, {:conditions => "annual_hw_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    sw = Contract.count(:account_name, {:conditions => "annual_sw_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    sa = Contract.count(:account_name, {:conditions => "annual_sa_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    ce = Contract.count(:account_name, {:conditions => "annual_ce_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    dr = Contract.count(:account_name, {:conditions => "annual_dr_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    total = Contract.count(:account_name, {:conditions => "expired <> 1", :group => 'sales_office_name'})

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

  # For Dashboard report
  def self.customer_counts_by_office
    offices = Contract.find(:all, :select => 'DISTINCT sales_office_name', :conditions => 'expired <> 1', :order => 'sales_office_name')
    hash = {}
    offices.length.times do |x|
      hash[offices[x].sales_office_name] = {'hw' => 0, 'sw' => 0, 'sa' => 0, 'ce' => 0, 'dr' => 0, 'total' => 0 }
    end
    hw = Contract.count(:account_name, {:distinct => true, :conditions => "annual_hw_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    sw = Contract.count(:account_name, {:distinct => true, :conditions => "annual_sw_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    sa = Contract.count(:account_name, {:distinct => true, :conditions => "annual_sa_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    ce = Contract.count(:account_name, {:distinct => true, :conditions => "annual_ce_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    dr = Contract.count(:account_name, {:distinct => true, :conditions => "annual_dr_rev > 0 AND expired <> true", :group => 'sales_office_name'})
    total = Contract.count(:account_name, {:distinct => true, :conditions => "expired <> 1", :group => 'sales_office_name'})


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

  # For Dashboard report
  def self.revenue_by_office_by_type(date = nil)
    if date.nil?
      Contract.find(:all,
        :select => 'sales_office_name, sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total, sum(annual_hw_rev) as hw, sum(annual_sw_rev) as sw, sum(annual_sa_rev) as sa, sum(annual_ce_rev) as ce, sum(annual_dr_rev) as dr',
        :conditions => 'expired <> true',
        :group => 'sales_office_name')
    else
      Contract.find(:all,
        :select => 'sales_office_name, sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total, sum(annual_hw_rev) as hw, sum(annual_sw_rev) as sw, sum(annual_sa_rev) as sa, sum(annual_ce_rev) as ce, sum(annual_dr_rev) as dr',
        :conditions => ["start_date <= ? AND end_date >= ?", date, date],
        :group => 'sales_office_name')
    end
  end

	def self.customer_rev_list_by_sales_office
		Contract.find(:all, :select => 'account_name, sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total, sales_office_name', :conditions => 'expired <> true OR (start_date <= DATE(Now()) AND end_date > DATE(Now() ) )', :group => 'account_name, sales_office_name')
	end

	def self.customer_rev_list_by_support_office (teams)
		Contract.find(:all,
      :select => 'account_name, sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as revenue, support_office_name',
      :conditions => ['support_office IN (?) AND (expired <> true OR (start_date <= DATE(Now()) AND end_date > DATE(Now() ) ))', teams],
      :group => 'account_name, support_office_name',
      :order => 'revenue DESC')
	end

	def self.revenue_total(teams)
		Contract.find(:all,
			:select => 'sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as revenue')
	end

  # Calculates the actual discount of a Contract
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

  # For newbusiness report
  def self.newbusiness
    Contract.find(:all,
      :select => "contracts.*, CONCAT(users.first_name, ' ', users.last_name) AS sales_rep_name, (annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as tot_rev",
      :joins => "LEFT JOIN users ON contracts.sales_rep_id = users.id",
      :conditions => "payment_terms <> 'Bundled'").map { |x|  x unless x.renewal? }.compact
  end

  # String: po_received date translated to YYYYM.
  # Useful for in-place filtering based on date
  def period
    month = self.po_received.month
    self.po_received.year.to_s + month.to_s
  end

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

  def hw_support_level_multiplier
    case hw_support_level_id
      when "SDC 24x7" then 1
      when "SDC SD" then BigDecimal.new('0.83')
      when "SDC ND" then BigDecimal.new('0.65')
      when "SDC CS" then BigDecimal.new('1.65')
      else 1
    end
  end

  def sw_support_level_multiplier
    case sw_support_level_id
      when "SDC SW 24x7" then 1
      when "SDC SW 13x5" then BigDecimal.new('0.83')
      else 1
    end
  end

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
  # - They contain line items that have a support provider != 'Sourcedirect'
  # - They are current
  # - Some of the line items that have a support provider != 'Sourcedirect' also have subcontractor_id == nil
  def Contract.missing_subcontracts
    #debugger
    contract_ids = LineItem.find(:all, :select => "contract_id", :conditions => "support_provider <> 'Sourcedirect' AND subcontract_id IS NULL").map {|l| l.contract_id}.uniq
    #logger.debug "Contract IDs found:"
    #logger.debug contract_ids.size
    @contracts = Contract.current_unexpired.find(:all, :conditions => ["id IN (?)", contract_ids])
    #@contracts.each do |c|
    #  logger.debug "Contract #{c.id}:"
    #  c.line_items.each do |l|
    #    logger.debug "LineItem #{l.id}"
    #    logger.debug l.support_provider
    #    logger.debug l.subcontract_id
    #  end
    #end
    @contracts
  end


  protected

  # This method updates the account_name field from SugarCRM for all the Contracts with a matching account_id
  def update_account_name_from_sugar
    Contract.update_all(["account_name = ?", sugar_acct && sugar_acct.name ], ["account_id = ?", account_id])
  end

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
