# See SupportDeal for schema
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

  #Calculates the amount of change, per contract, bewteen current year and previous year
  def renewal_attrition
    if predecessors.size > 0
      @attrition = total_revenue - predecessors.inject(0) {|sum, n| sum + n.total_revenue}
    else
      @attrition = 0
    end
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

end
