class ReportsController < ApplicationController
  before_filter :login_required

  # GET /reports
  def index
    #Contract counts
    @total_contract_count = Contract.total_contract_count
    @total_hw_only_contract_count = Contract.total_hw_contract_count
    @total_sw_only_contract_count = Contract.total_sw_contract_count
    @total_sa_contract_count = Contract.total_sa_contract_count
    @total_ce_contract_count = Contract.total_ce_contract_count
    @total_dr_contract_count = Contract.total_dr_contract_count

    #Customer counts
    @total_customer_count = Contract.total_customer_count
    @total_hw_only_customer_count = Contract.total_hw_customer_count
    @total_sw_only_customer_count = Contract.total_sw_customer_count
    @total_sa_customer_count = Contract.total_sa_customer_count
    @total_ce_customer_count = Contract.total_ce_customer_count
    @total_dr_customer_count = Contract.total_dr_customer_count

    #Revenue totals
    @all_revenue = Contract.all_revenue
    
    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def renewals
    #@total_contract_count = Contract.total_contract_count
    #@total_customer_count = Contract.total_customer_count
    
    respond_to do |format|
      format.html # renewals.html.haml
    end
  end
  
  def sparesreq
    @total_contract_count = Contract.total_contract_count
    @total_customer_count = Contract.total_customer_count
    
    respond_to do |format|
      format.html # sparesreq.html.haml
    end
  end
end
