class ReportsController < ApplicationController
  include QuarterlyDates
  #TODO: Add filtering based on role to allow viewing of reports
  # GET /reports
  def index
    #Counts
    @contract_counts_by_office = Contract.contract_counts_by_office
    @customer_counts_by_office = Contract.customer_counts_by_office
    @total_contracts = @contract_counts_by_office.map { |k, v| @contract_counts_by_office[k]['total'] }.sum
    @total_customers = @customer_counts_by_office.map { |k, v| @customer_counts_by_office[k]['total'] }.sum
    @unrenewed_amount = Contract.non_renewing_contracts(Date.today - 1.year, Date.today)
    @attrition_amount = Contract.existing_revenue_change

    @offices = []
    n = 0
    @contract_counts_by_office.each_key do |k|
      @offices[n] = k
      n = n+1
    end
    @offices.sort!
    #Revenue totals
    begin
      @date = Date.parse(params[:date]) if params[:date]
    rescue ArgumentError
      flash[:notice] = 'Invalid Date!'
    end
    @all_revenue = Contract.all_revenue(@date)
    @revenue_by_office_by_type = Contract.revenue_by_office_by_type(@date)
    @date ||= Date.today
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
    @contracts = Contract.renewals_next_90_days(current_user.sugar_team_ids, @ref_date)
    @offices = @contracts.map { |x| x.sales_office_name }.uniq.sort
    @sales_reps = @contracts.map { |x| x.sales_rep.full_name }.uniq.sort
    respond_to do |format|
      format.html # renewals.html.haml
      format.xls #create excel doc
    end
  end

  def sparesreq
    @offices = current_user.has_role?(:admin, :manager, :purchasing) ? LineItem.locations : SugarTeam.dropdown_list(current_user.sugar_team_ids).map { |x| x.name }
    if params[:filter] != nil
      @office = params[:filter][:office_name]
      @lineitems = LineItem.sparesreq(@office)
    else
      @lineitems = []
    end

    respond_to do |format|
      format.html # sparesreq.html.haml
    end
  end

  def customers
    @office = params[:filter][:office_name] unless params[:filter].nil?
    @customers = Contract.customer_rev_list_by_support_office(current_user.sugar_team_ids)
    @offices = @customers.map { |x| x.support_office_name }.uniq.sort
    #@offices.uniq!.sort!
    @all_revenue = Contract.all_revenue

  end

  def newbusiness
    logger.debug "************** reports/newbusiness action"
    @contracts = Contract.newbusiness
    #TODO: Change to AJAX requests for report?
    #generate the filter dropdown:
    @period_names = []
    @period_ids = []
    (2003..Date.today.year).to_a.each do |y|
      1.upto(12) { |m| @period_names << Date::MONTHNAMES[m] + " " + y.to_s; @period_ids << y.to_s + m.to_s }
    end
    @periods = @period_names.zip(@period_ids)
    @currperiod = Date.today.year.to_s + Date.today.month.to_s
    respond_to do |format|
      format.html { render :html => @contracts } # index.html.haml
      format.xls #Respond as Excel Doc
    end
  end

  def oldbusiness
    logger.debug "************** reports/oldbusiness action"
    @contracts = Contract.oldbusiness
    #TODO: Change to AJAX requests for report?
    #generate the filter dropdown:
    @period_names = []
    @period_ids = []
    (2003..Date.today.year).to_a.each do |y|
      1.upto(12) { |m| @period_names << Date::MONTHNAMES[m] + " " + y.to_s; @period_ids << y.to_s + m.to_s }
    end
    @periods = @period_names.zip(@period_ids)
    @currperiod = Date.today.year.to_s + Date.today.month.to_s
    respond_to do |format|
      format.html { render :html => @contracts } # index.html.haml
      format.xls #Respond as Excel Doc
    end
  end

  def potentialoffices
    @locations = LineItem.hw_revenue_by_location
  end

  def missing_subcontracts
    @contracts = Contract.missing_subcontracts
  end

  def spares_assessment
    @offices = SugarTeam.dropdown_list(current_user.sugar_team_ids).map { |x| x.name }
    if params[:filter] != nil && params[:filter][:office_name] != nil
      @office = params[:filter][:office_name]
      @lineitems = LineItem.sparesreq(@office)
    else
      @office = nil
      @lineitems = []
    end
  end

  def variable_billing
    contracts = Contract.current_unexpired.find(:all, :conditions => 'payment_terms NOT IN ("Bundled", "Annual", "Annual+MY") AND revenue > 0')
    @contracts = contracts.select { |c| c.billing_fluctuates? }
  end

  def customer_change_detail
    @old_date = Date.today - 1.year
    account_ids = Contract.accounts_as_of(@old_date)
    @customers = SugarAcct.find(account_ids)
  end

  def sam_needed
    @customers = Contract.find(:all, :select => 'support_deals.*, min(start_date) as min_start_date ', :conditions => '(expired = 0) AND (basic_remote_monitoring = 1 OR basic_backup_auditing = 1)', :group => 'account_id')
    @customers.delete_if { |customer| customer.sugar_acct.sugar_accounts_cstm.rmmhubdeployed_c == true }
  end

  def po_receiving
    @ref_date ||= (Date.today.- 365.days).strftime("%Y-%m-%d")
    if params[:date_search] != nil
      if params[:date_search][:ref_date] != nil && params[:date_search][:ref_date] != ''
        @ref_date = params[:date_search][:ref_date]
      end
    end
    @contracts = Contract.find(:all, :conditions => ["po_received >= ?", @ref_date], :order => :po_received)
    respond_to do |format|
      format.html # renewals.html.haml
      format.xls #create excel doc
    end
  end

  def sa_days
    @contracts = Contract.find(:all,
                               :select => 'support_deals.*, sa_days + ce_days AS sum_sa_days',
                               :include => :sugar_acct,
                               :conditions => '(sa_days IS NOT NULL OR ce_days IS NOT NULL) AND (sa_days > 0 OR ce_days > 0) AND end_date > NOW()')
    @offices = @contracts.map { |x| x.support_office_name }.uniq.sort

  end

  def quota
    unless current_user.has_role? :manager
      @sales_rep = current_user
      @sales_reps = [[@sales_rep.full_name, @sales_rep.id]]
    end
    @sales_reps ||= Contract.all_sales_reps.map { |rep| [rep.full_name, rep.id] }.unshift([nil, nil])
    if params[:sales_rep_id] || @sales_rep
      @sales_rep ||= User.find(params[:sales_rep_id])
      salesman = @sales_rep ? @sales_rep.login : nil
      @prev_quarter_contract_pos = Contract.po_received_last_quarter.reject { |c| c.sales_rep_id != @sales_rep.id }
      @this_quarter_contract_pos = Contract.po_received_this_quarter.reject { |c| c.sales_rep.id != @sales_rep.id }
      prev_quarter_hardware_pos = FishbowlSo.received_last_quarter.reject { |c| c.salesman != salesman }
      this_quarter_hardware_pos = FishbowlSo.received_this_quarter.reject { |c| c.salesman != salesman }
      @prev_quarter_contracts = Contract.quota_last_quarter.reject { |c| c.sales_rep_id != @sales_rep.id }
      @this_quarter_contracts = Contract.quota_this_quarter.reject { |c| c.sales_rep_id != @sales_rep.id }
      @next_quarter_contracts = Contract.quota_next_quarter.reject { |c| c.sales_rep_id != @sales_rep.id }
      @prev_quarter_quota = @prev_quarter_contracts.sum(&:total_revenue) * BigDecimal.new('1.45')
      @this_quarter_quota = @this_quarter_contracts.sum(&:total_revenue) * BigDecimal.new('1.45')
      @next_quarter_quota = @next_quarter_contracts.sum(&:total_revenue) * BigDecimal.new('1.45')
      @prev_quarter_contract_attainment = @prev_quarter_contract_pos.sum(&:total_revenue)
      @this_quarter_contract_attainment = @this_quarter_contract_pos.sum(&:total_revenue)
      @next_quarter_contract_attainment = BigDecimal.new('0.0')
      @prev_quarter_hw_attainment = prev_quarter_hardware_pos.sum(&:profit)
      @this_quarter_hw_attainment = this_quarter_hardware_pos.sum(&:profit)
    else
      @noquery = true
      @sales_rep = User.new
    end
  end
end
