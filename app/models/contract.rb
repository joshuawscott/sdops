class Contract < SupportDeal

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

end
