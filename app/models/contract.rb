class Contract < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy

  has_many :succeeds, :foreign_key => :successor_id, :class_name => 'Relationship'
  has_many :precedes, :foreign_key => :predecessor_id, :class_name => 'Relationship'

  has_many :successors, :through => :precedes
  has_many :predecessors, :through => :succeeds
  
  has_many :comments, :as => :commentable
  
  #Validate General Details
  validates_presence_of :sdc_ref, :description, :sales_rep_id, :sales_office, :support_office
  validates_presence_of :account_id, :cust_po_num, :payment_terms
  
  #Validate Revenue
  validates_presence_of :revenue #, :annual_hw_rev, :annual_sw_rev, :annual_ce_rev
  #validates_presence_of :annual_sa_rev, :annual_dr_rev
  
  #Validate Discounts
  #validates_presence_of :discount_pref_hw, :discount_pref_sw, :discount_prepay, :discount_multiyear
  #validates_presence_of :discount_ce_day, :discount_sa_day
  
  #Validate Terms
  validates_presence_of :start_date, :end_date
  #validates_presence_of :hw_support_level_id, :sw_support_level_id, :updates, :ce_days, :sa_days
  
  def self.short_list(role, teams)
    if role >= MANAGER
      #Contract.find(:all, :select => "id, sales_office_name, support_office_name, said, description, payment_terms, start_date, end_date, round(revenue,2) as revenue, account_name", :conditions => "expired <> true")
      Contract.find(:all, :select => "id, sales_office_name, support_office_name, said, description, start_date, end_date, payment_terms, revenue, account_name", :conditions => "expired <> true", :order => 'sales_office, account_name, start_date')
    else
      #Contract.find(:all, :select => "id, sales_office_name, support_office_name, said, description, payment_terms, start_date, end_date, round(revenue,2) as revenue, account_name", :conditions => ["sales_office IN (?) AND expired <> true", teams])
      Contract.find(:all, :select => "id, sales_office_name, support_office_name, said, description, start_date, end_date, payment_terms, revenue, account_name", :conditions => ["sales_office IN (?) AND expired <> true", teams], :order => 'sales_office, account_name, start_date')
    end
  end

  def self.serial_search(role, teams, serial_num)
    if role >= MANAGER
      #Contract.find(:all, :select => "contracts.id, sales_office_name, support_office_name, said, contracts.description, payment_terms, start_date, end_date, round(revenue,2) as revenue, account_name",
      #  :joins => :line_items, :conditions => ['line_items.serial_num = ?', serial_num])
      Contract.find(:all, :select => "contracts.id, sales_office_name, support_office_name, said, contracts.description, start_date, end_date, payment_terms, revenue, account_name",
        :joins => :line_items, :conditions => ['line_items.serial_num = ?', serial_num])
    else
      #Contract.find(:all, :select => "contracts.id, sales_office_name, support_office_name, said, contracts.description, payment_terms, start_date, end_date, round(revenue,2) as revenue, account_name",
      #  :joins => :line_items, :conditions => ["contracts.sales_office IN (?) AND line_items.serial_num = ?", teams, serial_num])
      Contract.find(:all, :select => "contracts.id, sales_office_name, support_office_name, said, contracts.description, start_date, end_date, payment_terms, revenue, account_name",
        :joins => :line_items, :conditions => ["contracts.sales_office IN (?) AND line_items.serial_num = ?", teams, serial_num])
    end
  end
  
  def total_revenue
     annual_hw_rev + annual_sw_rev + annual_ce_rev + annual_sa_rev + annual_dr_rev
  end
  
  #All Contracts  sum(revenue) as rev, sum(annual_hw_rev) as hw, sum(annual_sw_rev) as sw
  def self.total_customer_count
    Contract.count(:account_id, {:distinct => true, :conditions => "expired <> 1"})
  end
  
  def self.total_contract_count
    Contract.count(:account_id, :conditions => "expired <> 1")
  end

  def self.all_revenue
    Contract.find(:all, :select => 'sum(annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as total_revenue, sum(annual_hw_rev) as annual_hw_rev, sum(annual_sw_rev) as annual_sw_rev, sum(annual_sa_rev) as annual_sa_rev, sum(annual_ce_rev) as annual_ce_rev, sum(annual_dr_rev) as annual_dr_rev', :conditions => "expired <> 1")
  end

  def self.total_hw_contract_count
    Contract.count(:account_id, :conditions => "annual_hw_rev > 0 AND expired <> 1")
  end

  def self.total_hw_customer_count
    Contract.count(:account_id, {:distinct => true, :conditions => "annual_hw_rev > 0 AND expired <> 1"})
  end

  def self.total_sw_contract_count
    Contract.count(:account_id, :conditions => "annual_sw_rev > 0 AND expired <> 1")
  end

  def self.total_sw_customer_count
    Contract.count(:account_id, {:distinct => true, :conditions => "annual_sw_rev > 0 AND expired <> 1"})
  end

  def self.total_sa_contract_count
    Contract.count(:account_id, :conditions => "annual_sa_rev > 0 AND expired <> 1")
  end

  def self.total_sa_customer_count
    Contract.count(:account_id, {:distinct => true, :conditions => "annual_sa_rev > 0 AND expired <> 1"})
  end

  def self.total_ce_contract_count
    Contract.count(:account_id, :conditions => "annual_ce_rev > 0 AND expired <> 1")
  end

  def self.total_ce_customer_count
    Contract.count(:account_id, {:distinct => true, :conditions => "annual_ce_rev > 0 AND expired <> 1"})
  end

  def self.total_dr_contract_count
    Contract.count(:account_id, :conditions => "annual_dr_rev > 0 AND expired <> 1")
  end

  def self.total_dr_customer_count
    Contract.count(:account_id, {:distinct => true, :conditions => "annual_dr_rev > 0 AND expired <> 1"})
  end
end





