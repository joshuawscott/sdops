class ContractsController < ApplicationController
  #only contract_admin's can make changes:
  before_filter :authorized?, :only => [:new, :create, :edit, :update, :destroy]
	# contract_manager's can make some changes:
  before_filter :manager?, :only => [:sentrenewal, :backtorenewals]
  before_filter :set_dropdowns, :only => [:new, :edit, :create, :update]

	#TODO: show current contracts, including those marked expired
  # GET /contracts
  # GET /contracts.xml
  def index
    @sales_offices =  SugarTeam.dropdown_list(current_user.sugar_team_ids).map {|x| [x.name, x.id]}
    @support_offices =  @sales_offices
    @pay_terms = Dropdown.payment_terms_list.map {|x| x.label}
    @pay_terms << "Not Bundled"
    if params[:serial_search] != nil
      @contracts = Contract.serial_search(params[:serial_search][:serial_number])
      @sn_warning = "NOTE: Serial Number search found approximate matches." if @contracts[0] && @contracts[0].sn_approximated == true
    elsif params[:search] != nil
      #Get search criteria from params object
      @sales_office ||= params[:search][:sales_office]
      @support_office ||= params[:search][:support_office]
      @account_name ||= params[:search][:account_name]
      @said ||= params[:search][:said]
      @description ||= params[:search][:description]
      @start_date ||= params[:search][:start_date]
      @end_date ||= params[:search][:end_date]
      @pay_term ||= params[:search][:payment_terms]
      @revenue ||= params[:search][:revenue]
      @expired ||= params[:search][:expired]
      #Create and set the scope conditions
      @contracts = Contract.scoped({})
      @contracts = @contracts.conditions "(support_deals.sales_office IN (?) OR support_deals.support_office IN(?))", current_user.sugar_team_ids, current_user.sugar_team_ids
      @contracts = @contracts.conditions "support_deals.sales_office = ?", @sales_office unless @sales_office.blank?
      @contracts = @contracts.conditions "support_deals.support_office = ?", @support_office unless @support_office.blank?
      @contracts = @contracts.conditions "support_deals.account_name like ?", "%"+@account_name+"%" unless @account_name.blank?
      @contracts = @contracts.conditions "support_deals.said like ?", "%"+@said+"%" unless @said.blank?
      op, val = @revenue.split(" ")
      @contracts = @contracts.conditions "(support_deals.annual_hw_rev + support_deals.annual_sw_rev + support_deals.annual_ce_rev + support_deals.annual_sa_rev + support_deals.annual_dr_rev) #{op} ?", val.to_f unless @revenue.blank?
    
      if @pay_term =~ /^Not/
        @contracts = @contracts.conditions "support_deals.payment_terms <> 'bundled'"
      else
        @contracts = @contracts.conditions "support_deals.payment_terms = ?", @pay_term unless @pay_term.blank?
      end
      @contracts = @contracts.conditions "support_deals.description like ?", "%"+@description+"%" unless @description.blank?
      op, val = @start_date.split(" ")
      @contracts = @contracts.conditions "support_deals.start_date #{op} ?", val unless @start_date.blank?
      op, val = @end_date.split(" ")
      @contracts = @contracts.conditions "support_deals.end_date #{op} ?", val unless @end_date.blank?
      @contracts = @contracts.conditions "support_deals.expired <> true" unless @expired == "on"
      @contracts
    elsif params[:export] != nil
      #Get search criteria from params object
      @sales_office ||= params[:export][:sales_office]
      @support_office ||= params[:export][:support_office]
      @account_name ||= params[:export][:account_name]
      @said ||= params[:export][:said]
      @description ||= params[:export][:description]
      @start_date ||= params[:export][:start_date]
      @end_date ||= params[:export][:end_date]
      @pay_term ||= params[:export][:payment_terms]
      @revenue ||= params[:export][:revenue]
      @expired ||= params[:export][:expired]
      #Create and set the scope conditions
      @contracts = Contract.scoped({})
      @contracts = @contracts.conditions "(support_deals.sales_office IN (?) OR support_deals.support_office IN(?))", current_user.sugar_team_ids, current_user.sugar_team_ids
      @contracts = @contracts.conditions "support_deals.sales_office = ?", @sales_office unless @sales_office.blank?
      @contracts = @contracts.conditions "support_deals.support_office = ?", @support_office unless @support_office.blank?
      @contracts = @contracts.conditions "support_deals.account_name like ?", "%"+@account_name+"%" unless @account_name.blank?
      @contracts = @contracts.conditions "support_deals.said like ?", "%"+@said+"%" unless @said.blank?
      op, val = @revenue.split(" ")
      @contracts = @contracts.conditions "(support_deals.annual_hw_rev + support_deals.annual_sw_rev + support_deals.annual_ce_rev + support_deals.annual_sa_rev + support_deals.annual_dr_rev) #{op} ?", val.to_f unless @revenue.blank?
    
      if @pay_term =~ /^Not/
        @contracts = @contracts.conditions "support_deals.payment_terms <> 'bundled'"
      else
        @contracts = @contracts.conditions "support_deals.payment_terms = ?", @pay_term unless @pay_term.blank?
      end
      @contracts = @contracts.conditions "support_deals.description like ?", "%"+@description+"%" unless @description.blank?
      op, val = @start_date.split(" ")
      @contracts = @contracts.conditions "support_deals.start_date #{op} ?", val unless @start_date.blank?
      op, val = @end_date.split(" ")
      @contracts = @contracts.conditions "support_deals.end_date #{op} ?", val unless @end_date.blank?
      @contracts = @contracts.conditions "support_deals.expired <> true" unless @expired == "on"
      @contracts
      
    else
      @contracts = Contract.short_list(current_user.sugar_team_ids)
    end
    respond_to do |format|
      store_location
      format.html { render :html => @contracts }# index.html.haml
      format.xml  { render :xml => @contracts }
      format.xls  #Respond as Excel Doc
    end
  end

  # GET /contracts/1
  # GET /contracts/1.xml
  def show
    logger.debug "******* Contracts controller show method"
    @contract = Contract.find(params[:id])
    @comments = @contract.comments.sort {|x,y| y.created_at <=> x.created_at}
    @line_items = @contract.line_items.sort_by {|l| l.position}
    logger.debug "Line Items Found = #{@line_items.size}"
    x = LineItem.find(:first)
    logger.debug x.to_yaml
    @hwlines = @line_items.find_all {|e| e.support_type == "HW"}
    @swlines = @line_items.find_all {|e| e.support_type == "SW"}
    @srvlines = @line_items.find_all {|e| e.support_type == "SRV"}
    @replaces = @contract.predecessors
    @replaced_by = @contract.successors
    @comment = Comment.new
    @support_providers = Subcontractor.find(:all, :select => :name).map {|s| s.name}
    @support_providers.insert 0, "Sourcedirect"
    @sales_rep = User.find(@contract.sales_rep_id, :select => "first_name, last_name").full_name
    respond_to do |format|
      format.html do
        render :action => 'quote' if params[:quote]
        unless current_user.has_role?(:contract_admin, :manager) || (current_user.sugar_team_ids & [@contract.sales_office, @contract.support_office]).length > 0
          unless current_user.has_role?(:call_screener)
            flash[:error] = 'You are not allowed access to that contract!'
            redirect_to url_for(:action => 'index') and return
          end
          @restricted_user = true
          render :action => 'simple_show'
        end
      end
      format.xml  { render :xml => @contract }
      format.xls  #Respond as Excel Doc
    end
  end

  # GET /contracts/new
  # GET /contracts/new.xml
  def new
    @contract = Contract.new
    @replaces = []
    @replaced_by = []
   
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contract }
    end
  end

  # GET /contracts/1/edit
  def edit
    @contract = Contract.find(params[:id])
    @replaces = Contract.find(:all, :conditions => "account_name = '#{@contract.account_name.gsub(/\\/, '\&\&').gsub(/'/, "''")}' AND id <> #{params[:id]} AND start_date <= '#{@contract.start_date}'")
    @replaced_by = Contract.find(:all, :conditions => "account_name = '#{@contract.account_name.gsub(/\\/, '\&\&').gsub(/'/, "''")}' AND id <> #{params[:id]} AND end_date >= '#{@contract.end_date}'")

  end

  # POST /contracts
  # POST /contracts.xml
  def create
    logger.debug "******* Contracts controller create method"
    @contract = Contract.new(params[:contract])
    @replaces ||= []
    @replaced_by ||= []

    respond_to do |format|
      if @contract.save
        flash[:notice] = 'Contract was successfully created.'
        format.html { redirect_to(@contract) }
        format.xml  { render :xml => @contract, :status => :created, :location => @contract }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contract.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contracts/1
  # PUT /contracts/1.xml
  def update
    params[:contract][:predecessor_ids] ||= []
    params[:contract][:successor_ids] ||= []
    @contract = Contract.find(params[:id])
    @sugar_accts = SugarAcct.find(:all, :select => "id, name", :conditions => "deleted = 0", :order => "name")
    @sales_offices =  SugarTeam.dropdown_list(current_user.sugar_team_ids)
    @support_offices = @sales_offices
    @pay_terms = Dropdown.payment_terms_list
    @platform = Dropdown.platform_list
    @reps = User.user_list
    @types_hw = Dropdown.support_type_list_hw
    @types_sw = Dropdown.support_type_list_sw
    @replaces = Contract.find(:all, :conditions => "account_name = '#{@contract.account_name.gsub(/\\/, '\&\&').gsub(/'/, "''")}' AND id <> #{params[:id]} AND start_date <= '#{@contract.start_date}'")
    @replaced_by = Contract.find(:all, :conditions => "account_name = '#{@contract.account_name.gsub(/\\/, '\&\&').gsub(/'/, "''")}' AND id <> #{params[:id]} AND end_date >= '#{@contract.end_date}'")

    respond_to do |format|
      if @contract.update_attributes(params[:contract])
        flash[:notice] = 'Contract was successfully updated.'
        format.html { redirect_to(@contract) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contract.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contracts/1
  # DELETE /contracts/1.xml
  def destroy
    @contract = Contract.find(params[:id])
    logger.info current_user.login + " destroyed contract " + @contract.id.to_s
    @contract.destroy
    
    #Deleted associated Comments
    @comments = Comment.find(:all, :conditions => "commentable_id = #{params[:id]} AND commentable_type = 'Contract'")
    @comments.each {|x| x.destroy}
    
    respond_to do |format|
      format.html { redirect_to(contracts_url) }
      format.xml  { head :ok }
    end
  end

	def sentrenewal
    logger.debug "******* Contracts controller sentrenewal method"
		@contract = Contract.find(params[:id])
	end

	def backtorenewals
    @contract = Contract.find(params[:id])
		params[:contract][:renewal_amount].gsub!(/[^0-9\.]/,"")
		respond_to do |format|
      if @contract.update_attributes(params[:contract])
				logger.debug "*** contract.update_atttributes(params[:contract]) is TRUE"
        flash[:notice] = 'Date was successfully updated.'
        format.html { redirect_to('/reports/renewals') }
        format.xml  { head :ok }
      else
				logger.debug "*** contract.update_atttributes(params[:contract]) is FALSE"
        format.html { render :action => "sentrenewal" }
        format.xml  { render :xml => @contract.errors, :status => :unprocessable_entity }
      end
    end
	end

  def lineitems # exports line items to excel
    logger.debug "******* Contracts controller lineitems (export to excel) method"
    @contract = Contract.find(params[:id])
    @line_items = @contract.line_items
    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @contract }
      format.xls  #Respond as Excel Doc
    end    
  end

  def quote
    #expires_in 1.minute, :private => nil, :public => true
    response.headers['Cache-Control'] = 'private, max-age=120'
    @contract = Contract.find(params[:id])
    @line_items = LineItem.find(:all, :conditions => {:support_deal_id => params[:id]})
    multiyear = @contract.discount_multiyear > 0.0
    prepay = true
    @best_discount_amount = @contract.discount_amount(:type => :hw, :prepay => prepay, :multiyear => multiyear) + @contract.discount_amount(:type => :sw, :prepay => prepay, :multiyear => multiyear) + @contract.discount_amount(:type => :srv, :prepay => prepay, :multiyear => multiyear)
    prawnto :prawn => {:page_layout => :landscape}, :inline => false
  end

  protected
  def authorized?
    current_user.has_role?(:admin, :contract_admin) || not_authorized
  end

	def manager?
		current_user.has_role?(:renewals_manager) || not_authorized
	end

  def set_dropdowns
    @sugar_accts = SugarAcct.find(:all, :select => "id, name", :conditions => "deleted = 0", :order => "name")
    @sales_offices =  SugarTeam.dropdown_list(current_user.sugar_team_ids)
    @support_offices = @sales_offices
    @pay_terms = Dropdown.payment_terms_list
    @platform = Dropdown.platform_list
    @reps = User.user_list
    @types_hw = Dropdown.support_type_list_hw
    @types_sw = Dropdown.support_type_list_sw
  end
end
