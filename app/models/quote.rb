class Quote < SupportDeal
  def update_revenue
    @revenue = new_revenue
    @annual_hw_revenue = new_annual_hw_revenue
    @annual_sw_revenue = new_annual_sw_revenue
    @annual_ce_revenue = new_annual_ce_revenue
    @annual_sa_revenue = new_annual_sa_revenue
    @annual_dr_revenue = new_annual_dr_revenue
    self.save
  end
end
