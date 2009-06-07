class ReportsController < ApplicationController
  #TODO: Add filtering based on role to allow viewing of reports
  # GET /reports
  def index
		#Counts
    @contract_counts_by_office = Contract.contract_counts_by_office
    @customer_counts_by_office = Contract.customer_counts_by_office
    @total_contracts = @contract_counts_by_office.map{|k,v| @contract_counts_by_office[k]['total']}.sum
    @total_customers = @customer_counts_by_office.map{|k,v| @customer_counts_by_office[k]['total']}.sum
    
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
    @offices = @contracts.map{|x| x.sales_office_name}
    @offices.uniq!.sort!
    @userrole = current_user.role
    respond_to do |format|
      format.html # renewals.html.haml
    end
  end
  
  def sparesreq
    
    @offices = LineItem.locations(current_user.role, current_user.sugar_team_ids)
    if params[:filter] != nil
      @office = params[:filter][:office_name]
      @lineitems = LineItem.find(:all,
        :select => 'l.product_num, l.description, sum(l.qty) as count',
        :conditions => ['l.support_provider = "Sourcedirect" AND l.location = ? AND l.support_type = "HW" AND l.product_num <> "LABEL" AND (l.ends > CURDATE() AND l.begins < ADDDATE(CURDATE(), INTERVAL 30 DAY) OR c.expired <> true)', params[:filter][:office_name]],
        :joins => 'as l inner join contracts c on c.id = l.contract_id',
        :group => 'l.product_num')
        
    else
      @lineitems = []
    end
    
    respond_to do |format|
      format.html # sparesreq.html.haml
    end
  end
  
  def customers
		
		if params[:filter] != nil
			@office = params[:filter][:office_name]
			@customers = Contract.customer_rev_list_by_support_office(current_user.role, current_user.sugar_team_ids)
		else
			@customers = Contract.customer_rev_list_by_support_office(current_user.role, current_user.sugar_team_ids)
		end
		
		@offices = @customers.map{|x| x.support_office_name}
		@offices.uniq!.sort!
		@all_revenue = Contract.all_revenue
	
  end

  def newbusiness
    logger.debug "************** reports/newbusiness action"
    @contracts = Contract.newbusiness
    
    #generate the filter dropdown:
    @period_names = []
    @period_ids = []
    (2003..Date.today.year).to_a.each do |y|
      1.upto(12) {|m| @period_names << Date::MONTHNAMES[m] + " " + y.to_s; @period_ids << y.to_s + m.to_s}
    end
    @periods = @period_names.zip(@period_ids)
    @currperiod = Date.today.year.to_s + Date.today.month.to_s
    respond_to do |format|
      format.html { render :html => @contracts }# index.html.haml
      format.xls  #Respond as Excel Doc
    end
  end

  def potentialoffices
    @locations = LineItem.hw_revenue_by_location
  end

end
