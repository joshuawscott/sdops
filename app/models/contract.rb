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
class Contract < ActiveRecord::Base
  require "parsedate.rb"
  include ParseDate
  
  has_many :line_items, :dependent => :destroy

  has_many :succeeds, :foreign_key => :successor_id, :class_name => 'Relationship'
  has_many :precedes, :foreign_key => :predecessor_id, :class_name => 'Relationship'

  has_many :successors, :through => :precedes
  has_many :predecessors, :through => :succeeds
  
  has_many :comments, :as => :commentable
  
  #Validate General Details
  validates_presence_of :account_id, :sales_office, :support_office, :sales_rep_id
  
  #Validate Terms
  validates_presence_of :start_date, :end_date
  validates_presence_of :po_received
  def self.short_list(role, teams)
    if role >= ADMIN
      Contract.find(:all, :select => "id, sales_office_name, support_office_name, said, description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name", :conditions => "expired <> true", :order => 'sales_office, account_name, start_date', :group => 'id')
    else
      Contract.find(:all, :select => "id, sales_office_name, support_office_name, said, description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name", :conditions => ["sales_office IN (?) AND expired <> true", teams], :order => 'sales_office, account_name, start_date', :group => 'id')
    end
  end

  # Returns Contracts where Contracts.LineItem.serial_num matches serial_num
  def self.serial_search(serial_num)
		#TODO: Use passed parameters to determine if expired are shown.
      Contract.find(:all, :select => "DISTINCT contracts.id, sales_office_name, support_office_name, said, contracts.description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name",
        :joins => :line_items,
				:conditions => ['expired <> 1 AND line_items.serial_num = ?', serial_num])
  end

  # Returns Contracts with end_date in the next 90 days, unless Contract.expired = 1
  def self.renewals_next_90_days(role, teams, ref_date)
    if ref_date.nil? 
      ref_date = Date.today
    else
      ref_date = ParseDate.parsedate(ref_date)
      ref_date = Date.new(ref_date[0], ref_date[1], ref_date[2])
    end
    
    plus90 = ref_date.months_since(3)
    if role >= ADMIN
      Contract.find(:all, 
				:select => "id, sales_office_name, description, start_date, end_date, (annual_hw_rev + annual_sw_rev + annual_ce_rev + annual_sa_rev + annual_dr_rev) as revenue, account_name, DATEDIFF(end_date, '#{ref_date}') as days_due, renewal_sent, renewal_amount",
				:conditions => "end_date <= '#{plus90}' AND expired <> 1", 
				:order => 'sales_office, days_due')
    else
      Contract.find(:all, 
				:select => "id, sales_office_name, description, start_date, end_date, (annual_hw_rev + annual_sw_rev + annual_ce_rev + annual_sa_rev + annual_dr_rev) as revenue, account_name, DATEDIFF(end_date, '#{ref_date}') as days_due, renewal_sent, renewal_amount", 
				:conditions => ["end_date <= '#{plus90}' AND expired <> 1 AND sales_office IN (?)", teams], 
				:order => 'sales_office, days_due')
    end
  end
  
  # Total Annual Revenue
  def total_revenue
     annual_hw_rev + annual_sw_rev + annual_ce_rev + annual_sa_rev + annual_dr_rev
  end

  # Returns string "Renewal" if the Contract has a predecessor, otherwise returns
  # an empty string.
  def status
    if self.renewal?
      'Renewal'
    else
      
    end
  end

  # Returns true if the Contract has predecessor(s), otherwise false
  def renewal?
    if self.predecessor_ids.size > 0
      true
    else
      false
    end
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

	def self.customer_rev_list_by_support_office (role, teams)
		if role >= ADMIN
			Contract.find(:all, 
				:select => 'account_name, sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as revenue, support_office_name', 
				:conditions => 'expired <> true OR (start_date <= DATE(Now()) AND end_date > DATE(Now() ) )', 
				:group => 'account_name, support_office_name',
				:order => 'revenue DESC')
		else
			Contract.find(:all, 
				:select => 'account_name, sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as revenue, support_office_name', 
				:conditions => ['support_office IN (?) AND (expired <> true OR (start_date <= DATE(Now()) AND end_date > DATE(Now() ) ))', teams], 
				:group => 'account_name, support_office_name',
				:order => 'revenue DESC')
		end
		
	end

	def self.revenue_total(teams)
		Contract.find(:all,
			:select => 'sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as revenue')
	end

  # Calculates the actual discount of a Contract
  def effective_hw_discount
    total_list = 0.0
    self.line_items.each do |x|
      if x.support_type == 'HW'
        x.list_price ||= 0.0
        total_list += x.list_price
      end
    end
    1.0 - (self.annual_hw_rev / (total_list * 12))
  end

  # For newbusiness report
  def self.newbusiness
    Contract.find(:all, 
      :select => "contracts.*, CONCAT(users.first_name, ' ', users.last_name) AS sales_rep_name",
      :joins => "LEFT JOIN users ON contracts.sales_rep_id = users.id",
      :conditions => "payment_terms <> 'Bundled'").map { |x|  x unless x.renewal? }
  end

  # String: po_received date translated to YYYYM.
  # Useful for in-place filtering based on date
  def period
    @month = self.po_received.month
    self.po_received.year.to_s + @month.to_s
  end

end
