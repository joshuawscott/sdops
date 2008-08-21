class ReportsController < ApplicationController
  before_filter :login_required

  # GET /reports
  def index
    @total_contract_count = Contract.total_contract_count(current_user.office, current_user.role)
    @total_customer_count = Contract.total_customer_count(current_user.office, current_user.role)
    @total_hw_customer_count = Contract.total_hw_customer_count(current_user.office, current_user.role)
    @total_sw_customer_count = Contract.total_sw_customer_count(current_user.office, current_user.role)
    @total_sa_customer_count = Contract.total_sa_customer_count(current_user.office, current_user.role)
    @total_ce_customer_count = Contract.total_ce_customer_count(current_user.office, current_user.role)
    @total_dr_customer_count = Contract.total_dr_customer_count(current_user.office, current_user.role)
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end


end
