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

  def self.short_list(teams)
    Contract.find(:all, :select => "id, sales_office_name, support_office_name, said, description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name", :conditions => ["(sales_office IN (?) OR support_office IN(?)) AND expired <> true", teams, teams], :order => 'sales_office, account_name, start_date', :group => 'id')
  end

  # Returns Contracts where Contracts.LineItem.serial_num matches serial_num
  def self.serial_search(serial_num)
		#TODO: Use passed parameters to determine if expired are shown.
      Contract.find(:all, :select => "DISTINCT contracts.id, sales_office_name, support_office_name, said, contracts.description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name",
        :joins => :line_items,
				:conditions => ['expired <> 1 AND line_items.serial_num = ?', serial_num])
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

  # Pulls just the revenue fields (for reports)
  def self.all_revenue
    Contract.find(:all, 
			:select => 'sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total_revenue, sum(annual_hw_rev) as annual_hw_rev, sum(annual_sw_rev) as annual_sw_rev, sum(annual_sa_rev) as annual_sa_rev, sum(annual_ce_rev) as annual_ce_rev, sum(annual_dr_rev) as annual_dr_rev', 
			:conditions => "expired <> true")
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
  def self.revenue_by_office_by_type
    Contract.find(:all, 
			:select => 'sales_office_name, sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total, sum(annual_hw_rev) as hw, sum(annual_sw_rev) as sw, sum(annual_sa_rev) as sa, sum(annual_ce_rev) as ce, sum(annual_dr_rev) as dr', 
			:conditions => 'expired <> true', 
			:group => 'sales_office_name')
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
      :select => "contracts.*, CONCAT(users.first_name, ' ', users.last_name) AS sales_rep_name",
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
    elsif discount_pref_hw && discount_pref_hw > 0.0
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
      line_items.each {|l| t += (l.current_list_price.nil? ? 0.0 : l.current_list_price * (l.qty.nil? ? 0.0 : l.qty)) if l.support_type == "SRV"}
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

  protected

  # This method updates the account_name field from SugarCRM for all the Contracts with a matching account_id
  def update_account_name_from_sugar
    Contract.update_all(["account_name = ?", sugar_acct.name ], ["account_id = ?", account_id])
  end


end
