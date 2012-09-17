# See SupportDeal for schema
# Test git & capistrano with file change
class Contract < SupportDeal

  validates_presence_of :payment_terms, :po_received
  #Validate Revenue
  validates_numericality_of :revenue, :annual_hw_rev, :annual_sw_rev, :annual_sa_rev, :annual_ce_rev, :annual_dr_rev
  validates_numericality_of :discount_pref_hw, :discount_pref_sw, :discount_pref_srv, :discount_prepay, :discount_multiyear, :discount_ce_day, :discount_sa_day
  before_save :update_line_item_effective_prices

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

  #Returns an array of contracts marked as will not renew.
  def self.unrenewed(startdate,enddate)
    contracts = Contract.find(:all, :conditions => ["expired = 1 AND end_date >= ? AND end_date <= ?", startdate, enddate]).reject {|c| c.successors.size > 0}
  end

  #Calculates the amount of change, per contract, bewteen current year and previous year
  def renewal_attrition
    if predecessors.size > 0
      @attrition = total_revenue - predecessors.inject(0) {|sum, n| sum + n.total_revenue}
    else
      @attrition = 0
    end
  end

  # Gets a list of all the customers from 1 year ago, calculates the
  # +total_revenue+ from those, and then calculates the same thing for those
  # customers' current +total_revenue+.
  #
  # Returns a Hash of BigDecimals:
  #   total   net change in contracts
  #   old_total   total as of 1 year ago.
  #   new_total   total of those same customers now (includes expired)
  #   percentage  percent change (absolute value of total / old_total)
  def self.existing_revenue_change
    old_contracts = Contract.find(:all, :conditions => ['start_date <= ? AND end_date >= ?', Date.today - 1.year, Date.today - 1.year])
    account_ids = old_contracts.map {|contract| contract.account_id}

    old_total = BigDecimal.new("0.0")
    old_contracts.each do |contract|
      old_total += contract.total_revenue
    end

    current_contracts = Contract.find(:all, :conditions => {:account_id => account_ids, :expired => 0})

    new_total = BigDecimal.new("0.0")
    current_contracts.each do |contract|
      new_total += contract.total_revenue
    end

    percentage = ((new_total - old_total) / old_total).abs
    return {:total => new_total - old_total, :old_total => old_total, :new_total => new_total, :percentage => percentage}
  end

  #returns an array of strings (+account_id+) as of +date+
  def self.accounts_as_of(date)
    self.find(:all, :conditions => ['start_date <= ? AND end_date >= ?', date, date]).map {|c| c.account_id}
  end
  # returns the amount of the
  def self.revenue_for_account(account_id, date=Date.today)
    contracts = self.find(:all, :conditions => ['account_id = ? AND start_date <= ? AND end_date >= ?', account_id, date, date] )
    @revenue_for_account = BigDecimal.new("0.0")
    contracts.each do |contract|
      @revenue_for_account += contract.total_revenue
    end
    return @revenue_for_account
  end
  # For newbusiness report
  def self.newbusiness
    self.find(:all,
      :select => "support_deals.*, CONCAT(users.first_name, ' ', users.last_name) AS sales_rep_name, (annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as tot_rev",
      :joins => "LEFT JOIN users ON support_deals.sales_rep_id = users.id",
      :conditions => "payment_terms <> 'Bundled'").map { |x|  x unless x.renewal? }.compact
  end

  # For oldbusiness report
  def self.oldbusiness
    self.find(:all,
      :select => "support_deals.*, CONCAT(users.first_name, ' ', users.last_name) AS sales_rep_name, (annual_hw_rev + annual_sw_rev + annual_sa_rev + annual_ce_rev + annual_dr_rev) as tot_rev",
      :joins => "LEFT JOIN users ON support_deals.sales_rep_id = users.id",
      :conditions => "payment_terms <> 'Bundled'").map { |x|  x if x.renewal? }.compact
  end

  # returns true if the monthly billing changes during the contract period.
  def billing_fluctuates?
    return false if self.expired
    return false if self.end_date < Date.today
    start_dates = line_items.reject {|l| l.list_price.nil? || l.list_price == 0 }.map { |line| line.begins }
    end_dates = line_items.reject {|l| l.list_price.nil? || l.list_price == 0 }.map { |line| line.ends }
    return false if start_dates.uniq.length == 1 && end_dates.uniq.length == 1
    return false if payment_schedule.uniq.length == 1
    true
  end

  def days_early
    return nil if po_received.nil?
    (start_date - po_received).to_i

  end

end
