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
  
  def self.short_list(role, teams)
    if role >= ADMIN
      Contract.find(:all, :select => "id, sales_office_name, support_office_name, said, description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name", :conditions => "expired <> true", :order => 'sales_office, account_name, start_date', :group => 'id')
    else
      Contract.find(:all, :select => "id, sales_office_name, support_office_name, said, description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name", :conditions => ["sales_office IN (?) AND expired <> true", teams], :order => 'sales_office, account_name, start_date', :group => 'id')
    end
  end

  def self.serial_search(role, teams, serial_num)
		#TODO: Use passed parameters to determine if expired are shown.
    if role >= ADMIN
      Contract.find(:all, :select => "contracts.id, sales_office_name, support_office_name, said, contracts.description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name",
        :joins => :line_items,
				:conditions => ['expired <> 1 AND line_items.serial_num = ?', serial_num])
    else
      Contract.find(:all, :select => "contracts.id, sales_office_name, support_office_name, said, contracts.description, start_date, end_date, payment_terms, annual_hw_rev, annual_sw_rev, annual_sa_rev, annual_ce_rev, annual_dr_rev, account_name",
        :joins => :line_items,
				:conditions => ["expired <> 1 AND contracts.sales_office IN (?) AND line_items.serial_num = ?", teams, serial_num])
    end
  end
  
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
				:select => "id, sales_office_name, description, start_date, end_date, (annual_hw_rev + annual_sw_rev + annual_ce_rev + annual_sa_rev + annual_dr_rev) as revenue, account_name, DATEDIFF(end_date, '#{ref_date}') as days_due",
				:conditions => "end_date <= '#{plus90}' AND expired <> 1", 
				:order => 'sales_office, days_due')
    else
      Contract.find(:all, 
				:select => "id, sales_office_name, description, start_date, end_date, (annual_hw_rev + annual_sw_rev + annual_ce_rev + annual_sa_rev + annual_dr_rev) as revenue, account_name, DATEDIFF(end_date, '#{ref_date}') as days_due", 
				:conditions => ["end_date <= '#{plus90}' AND expired <> 1 AND sales_office IN (?)", teams], 
				:order => 'sales_office, days_due')
    end
  end
    
  def total_revenue
     annual_hw_rev + annual_sw_rev + annual_ce_rev + annual_sa_rev + annual_dr_rev
  end
  
  def status
    if self.predecessor_ids.count > 0
      'Renewal'
    elseif
      
    end
  end
  
  def self.all_revenue
    Contract.find(:all, 
			:select => 'sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total_revenue, sum(annual_hw_rev) as annual_hw_rev, sum(annual_sw_rev) as annual_sw_rev, sum(annual_sa_rev) as annual_sa_rev, sum(annual_ce_rev) as annual_ce_rev, sum(annual_dr_rev) as annual_dr_rev', 
			:conditions => "expired <> true")
  end

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
		
end






