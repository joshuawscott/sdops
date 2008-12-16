class ContractsController < ApplicationController
  before_filter :login_required
  before_filter :authorized?, :only => [:new, :create, :edit, :update, :destroy]

	#TODO: show current contracts, including those marked expired
  # GET /contracts
  # GET /contracts.xml
  def index
    @sales_offices =  SugarTeam.dropdown_list(current_user.role, current_user.sugar_team_ids).map {|x| [x.name, x.id]}
    @support_offices =  @sales_offices
    @pay_terms = Dropdown.payment_terms_list.map {|x| x.label}
    @pay_terms << "Not Bundled"
    
    if params[:serial_search] != nil
      @serial_number = params[:serial_search][:serial_number]
      @contracts = Contract.serial_search(current_user.role, current_user.sugar_team_ids, @serial_number)
    else
      if params[:search] != nil
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
        @contracts = @contracts.conditions "contracts.sales_office IN (?)", current_user.sugar_team_ids
        @contracts = @contracts.conditions "contracts.sales_office = ?", @sales_office unless @sales_office.blank?
        @contracts = @contracts.conditions "contracts.support_office = ?", @support_office unless @support_office.blank?
        @contracts = @contracts.conditions "contracts.account_name like ?", "%"+@account_name+"%" unless @account_name.blank?
        @contracts = @contracts.conditions "contracts.said like ?", "%"+@said+"%" unless @said.blank?
        op, val = @revenue.split(" ")
        @contracts = @contracts.conditions "contracts.total_revenue #{op} ?", val unless @revenue.blank?

        if @pay_term =~ /^Not/
          @contracts = @contracts.conditions "contracts.payment_terms <> 'bundled'"
        else
          @contracts = @contracts.conditions "contracts.payment_terms = ?", @pay_term unless @pay_term.blank?
        end
        @contracts = @contracts.conditions "contracts.description like ?", "%"+@description+"%" unless @description.blank?
        op, val = @start_date.split(" ")
        @contracts = @contracts.conditions "contracts.start_date #{op} ?", val unless @start_date.blank?
        op, val = @end_date.split(" ")
        @contracts = @contracts.conditions "contracts.end_date #{op} ?", val unless @end_date.blank?
        @contracts = @contracts.conditions "contracts.expired <> true" unless @expired == "on"
        @contracts
      else
        @contracts = Contract.short_list(current_user.role, current_user.sugar_team_ids)
      end
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
    logger.error "******* Contracts controller show method"
    @contract = Contract.find(params[:id])
    @comments = @contract.comments.sort {|x,y| y.created_at <=> x.created_at}
    @line_items = @contract.line_items
    @replaces = @contract.predecessors
    @replaced_by = @contract.successors
    @comment = Comment.new
		@support_providers = Dropdown.support_provider_list
    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @contract }
    end
  end

  # GET /contracts/new
  # GET /contracts/new.xml
  def new
    @contract = Contract.new
    @sugar_accts = SugarAcct.find(:all, :select => "id, name", :order => "name")
    @sales_offices =  SugarTeam.dropdown_list(current_user.role, current_user.sugar_team_ids)
    @support_offices = @sales_offices
    @pay_terms = Dropdown.payment_terms_list
    @platform = Dropdown.platform_list
    @reps = User.user_list
    @types_hw = Dropdown.support_type_list_hw
    @types_sw = Dropdown.support_type_list_sw
    @contract_types = SugarContractType.find(:all, :select => "id, name", :conditions => "deleted = 0", :order => "list_order")
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
    @sugar_accts = SugarAcct.find(:all, :select => "id, name", :conditions => "deleted = 0", :order => "name")
    @sales_offices =  SugarTeam.dropdown_list(current_user.role, current_user.sugar_team_ids)
    @support_offices = @sales_offices
    @pay_terms = Dropdown.payment_terms_list
    @platform = Dropdown.platform_list
    @reps = User.user_list
    @types_hw = Dropdown.support_type_list_hw
    @types_sw = Dropdown.support_type_list_sw
    @contract_types = SugarContractType.find(:all, :select => "id, name", :conditions => "deleted = 0", :order => "list_order")
    @replaces = Contract.find(:all, :conditions => "account_name = '#{@contract.account_name.gsub(/\\/, '\&\&').gsub(/'/, "''")}' AND id <> #{params[:id]}")
    @replaced_by = @replaces

  end

  # POST /contracts
  # POST /contracts.xml
  def create
    logger.info "******* Contracts controller create method"
    @contract = Contract.new(params[:contract])

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
    @sales_offices =  SugarTeam.dropdown_list(current_user.role, current_user.sugar_team_ids)
    @support_offices = @sales_offices
    @pay_terms = Dropdown.payment_terms_list
    @platform = Dropdown.platform_list
    @reps = User.user_list
    @types_hw = Dropdown.support_type_list_hw
    @types_sw = Dropdown.support_type_list_sw
    @contract_types = SugarContractType.find(:all, :select => "id, name", :conditions => "deleted = 0", :order => "list_order")
    @replaces = Contract.find(:all, :conditions => "account_name = '#{@contract.account_name.gsub(/\\/, '\&\&').gsub(/'/, "''")}' AND id <> #{params[:id]}")
    @replaced_by = @replaces

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
    @contract.destroy
    
    #Deleted associated Comments
    @comments = Comment.find(:all, :conditions => "commentable_id = #{params[:id]} AND commentable_type = 'Contract'")
    @comments.each {|x| x.destroy}
    
    respond_to do |format|
      format.html { redirect_to(contracts_url) }
      format.xml  { head :ok }
    end
  end

  protected
  def authorized?
    current_user.role == ADMIN || not_authorized
  end

end
