class ReportsController < ApplicationController
  before_filter :login_required

  # GET /reports
  def index
    #Counts
    @contract_counts_by_office = Contract.contract_counts_by_office
    @customer_counts_by_office = Contract.customer_counts_by_office
    @offices = []
    n = 0
    @contract_counts_by_office.each_key do |k|
      @offices[n] = k
      n = n+1
    end
    @offices.sort!
    
    #Revenue totals
    @all_revenue = Contract.all_revenue
    @revenue_by_office_by_type = Contract.revenue_by_office_by_type
    
    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def renewals

    @ref_date = Date.today.strftime("%Y-%m-%d")
    if params[:date_search] != nil
      if params[:date_search][:ref_date] != nil && params[:date_search][:ref_date] != ''
        @ref_date = params[:date_search][:ref_date]
      end
    end

    
    @contracts = Contract.renewals_next_90_days(current_user.role, current_user.sugar_team_ids, @ref_date)
    respond_to do |format|
      format.html # renewals.html.haml
    end
  end
  
  def sparesreq
    
    respond_to do |format|
      format.html # sparesreq.html.haml
    end
  end
end
