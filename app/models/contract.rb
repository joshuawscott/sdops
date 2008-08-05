class Contract < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy

  has_many :succeeds, :foreign_key => :successor_id, :class_name => 'Relationship'
  has_many :precedes, :foreign_key => :predecessor_id, :class_name => 'Relationship'

  has_many :successors, :through => :precedes
  has_many :predecessors, :through => :succeeds
  
  #Validate General Details
  validates_presence_of :sdc_ref, :description, :sales_rep_id, :sales_office, :support_office
  validates_presence_of :account_id, :cust_po_num, :payment_terms, :platform
  
  #Validate Revenue
  validates_presence_of :revenue #, :annual_hw_rev, :annual_sw_rev, :annual_ce_rev
  #validates_presence_of :annual_sa_rev, :annual_dr_rev
  
  #Validate Discounts
  #validates_presence_of :discount_pref_hw, :discount_pref_sw, :discount_prepay, :discount_multiyear
  #validates_presence_of :discount_ce_day, :discount_sa_day
  
  #Validate Terms
  validates_presence_of :start_date, :end_date  #, :multiyr_end
  #validates_presence_of :hw_support_level_id, :sw_support_level_id, :updates, :ce_days, :sa_days
  
  def self.short_list(team, role)
    if role >= MANAGER
      Contract.find(:all, :select => "id, sales_office, support_office, said, description, cust_po_num, payment_terms, revenue, account_name")
    else
      Contract.find(:all, :select => "id, sales_office, support_office, said, description, cust_po_num, payment_terms, revenue, account_name",
        :conditions => ["sales_office = ?", team])
    end
  end
  
  def total_revenue
     annual_hw_rev + annual_sw_rev + annual_ce_rev + annual_sa_rev + annual_dr_rev
  end
  
  def self.total_customer_count(team, role)
    if role >= MANAGER
      Contract.count(:account_id, {:distinct => true, :conditions => ["start_date <= ? AND end_date >= ?", Date.today, Date.today]})
    else
      Contract.count(:account_id, {:distinct => true, :conditions => ["sales_office = ? AND start_date <= ? AND end_date >= ?", team, Date.today, Date.today]})
    end
  end
  
  def self.total_contract_count(team, role)
    if role >= MANAGER
      Contract.count(:account_id, {:conditions => ["start_date <= ? AND end_date >= ?", Date.today, Date.today]})
    else
      Contract.count(:account_id, {:conditions => ["sales_office = ? AND start_date <= ? AND end_date >= ?", team, Date.today, Date.today]})
    end
  end
end
