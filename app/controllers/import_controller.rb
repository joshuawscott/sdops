class ImportController < ApplicationController

  before_filter :login_required
  before_filter :authorized?, :only => [:new, :create, :edit, :update, :destroy]

  # GET /import
  def index
    @sugar_accts = SugarAcct.find(:all, :select => "concat(id, '|', name) as id, name", :conditions => "deleted = 0", :order => "name")
    @sales_reps = User.user_list
    @sales_offices =  SugarTeam.find(:all, :select => "concat(id, '|', name) as id, name", :conditions => "private = 0 AND deleted = 0 AND id <> 1", :order => "name")
    @support_offices = @sales_offices
    @pay_terms = Dropdown.payment_terms_list
    @platform = Dropdown.platform_list

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # POST /import
  def create()
    logger.info "***************\nStarting Import process"
    records = YAML::load( params[:importfile] )

    #Separate out the data
    contract_ary = records[0]
    line_items_ary = records[1..-1]
    aryAcct = params[:account_id].split('|')
    arySales = params[:sales_office].split('|')
    arySupport = params[:support_office].split('|')
    options = {'account_id' => aryAcct[0], 'account_name' => aryAcct[1], 'sales_rep_id' => params[:sales_rep_id], 'sales_office' => arySales[0], 'sales_office_name' => arySales[1], 'support_office' => arySupport[0], 'support_office_name' => arySupport[1], 'platform' => params[:platform]}
    contract_ary.ivars['attributes'].update(options)
    #Cleanup
    records = nil
   
    #Save new contract
    logger.info "Importing contract... "
    @contract = Contract.new(contract_ary.ivars['attributes'])

    #if Contract successfully saves then import
    #associated line items
    if @contract.save
      line_items_ary.each do |item|
        logger.info "Importing line item..."
        @line_item = @contract.line_items.new(item.ivars['attributes'])
        @line_item.save
      end
    end
    
    respond_to do |format|
      if !@contract.new_record?
        flash[:notice] = 'Contract was successfully created.'
        format.html { redirect_to(@contract) }
        format.xml  { render :xml => @contract, :status => :created, :location => @contract }
      else
        flash[:notice] = 'Contract was not successfully created.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @contract.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  protected  
  def authorized?
    current_user.role >= IMPORT || not_authorized
  end
  
end
