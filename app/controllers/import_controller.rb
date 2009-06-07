# This controller handles processing of an uploaded YAML file to create a new Contract.
class ImportController < ApplicationController
  before_filter :authorized?, :only => [:index, :create]
  before_filter :set_dropdowns, :only => [:index, :create]
  # GET /import
  def index
    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # POST /import
  def create()
    #TODO: javascript form checking?
    #because the import processing is so complex, we must do form checking in the controller
    #to avoid nils and NoMethodErrors
    if params["importfile"] == ""
      flash[:error] = "You must select a file to import"
      render :controller => :import, :action => :index and return
    else
      records = YAML::load( params[:importfile] )
    end
    if params["platform"] == "" || params["sales_office"] == "" || params["contract_type"] == "" || params["sales_rep_id"] == "" || params["po_received"] == ""
      flash[:error] = "Please fill in all fields in red."
      render :controller => :import, :action => :index and return
    end
    if params["account_id"] == "" && params["contract"] == ""
      flash[:error] = "You must select either an account or a current contract"
      render :controller => :import, :action => :index and return
    end
    #Separate out the data
    contract_ary = records[0]
    line_items_ary = records[1..-1]
    aryAcct = params[:account_id].split('|')
    arySales = params[:sales_office].split('|')
    arySupport = params[:support_office].split('|')
    options = {'account_id' => aryAcct[0],
      'account_name' => aryAcct[1],
      'sales_rep_id' => params[:sales_rep_id],
      'sales_office' => arySales[0],
      'sales_office_name' => arySales[1],
      'support_office' => arySupport[0],
      'support_office_name' => arySupport[1],
      'platform' => params[:platform],
      'contract_type' => params[:contract_type],
      'po_received' => params[:po_received]}
    contract_ary.ivars['attributes'].update(options)

    #Cleanup
    records = nil

    #Save new contract
    #If this is an existing contract
    if params[:contract] != ""
      @contract = Contract.find(params[:contract])
      @contract.hw_support_level_id = contract_ary.ivars['attributes']['hw_support_level_id']
      @contract.sw_support_level_id = contract_ary.ivars['attributes']['sw_support_level_id']
      @contract.updates = contract_ary.ivars['attributes']['updates']
      @contract.said = contract_ary.ivars['attributes']['said']
      @contract.sales_rep_id = contract_ary.ivars['attributes']['sales_rep_id']
      @contract.sales_office = contract_ary.ivars['attributes']['sales_office']
      @contract.support_office = contract_ary.ivars['attributes']['support_office']
      @contract.sales_office_name = contract_ary.ivars['attributes']['sales_office_name']
      @contract.support_office_name = contract_ary.ivars['attributes']['support_office_name']
      @contract.platform = contract_ary.ivars['attributes']['platform']
      @contract.contract_type = contract_ary.ivars['attributes']['contract_type']
      @contract.cust_po_num = contract_ary.ivars['attributes']['cust_po_num']
    else # If this is a new contract
      @contract = Contract.new(contract_ary.ivars['attributes'])
    end

    #if Contract successfully saves then import
    #associated line items
    error_level = 0
    if @contract.save
      line_items_ary.each do |item|
        @line_item = @contract.line_items.new(item.ivars['attributes'])
        @line_item.location = @contract.support_office_name
        if @line_item.save
          #all good
        else
          logger.error "*************************"
          logger.error "LineItem failed to import"
          logger.error "for Contract ID # " + @contract.id
          logger.error "*************************"
          error_level += 1
        end
      end
    else
      logger.error "************************"
      logger.error "*Contract failed import*"
      logger.error "************************"
      error_level += 1
    end

    # Must reload contract, or update_line_item_effective_prices won't work.
    Contract.find(@contract).update_line_item_effective_prices if error_level == 0
    
    #Create contract in SugarCRM
    sugar_con = SugarContract.new
    sugar_con.id = create_guid

    sugar_con.name = @contract.description
    sugar_con.reference_code = @contract.said
    sugar_con.account_id = @contract.account_id
    sugar_con.start_date = @contract.start_date
    sugar_con.end_date = @contract.end_date
    sugar_con.currency_id = '-99'         
    sugar_con.total_contract_value = @contract.annual_hw_rev + @contract.annual_sw_rev + @contract.annual_ce_rev + @contract.annual_sa_rev + @contract.annual_dr_rev
    sugar_con.total_contract_value_usdollar = sugar_con.total_contract_value
    sugar_con.status = 'signed'
    sugar_con.expiration_notice = @contract.end_date
    sugar_con.description = "https://sdops/contracts/#{@contract.id}\n" + "Customer PO: #{@contract.cust_po_num}\n"
    sugar_con.assigned_user_id = User.find(@contract.sales_rep_id).sugar_id
    sugar_con.created_by = @contract.sales_rep_id
    sugar_con.date_entered = DateTime.now
    sugar_con.date_modified = DateTime.now
    sugar_con.modified_user_id = @contract.sales_rep_id
    sugar_con.team_id = @contract.sales_office
    sugar_con.type = @contract.contract_type
    
    if sugar_con.save == false
      flash[:error] = "Sugar Contract was not created"
      logger.error "Failed to create Sugar Contract for Contract ID# " + @contract.id
    end
    
    respond_to do |format|
      if !@contract.new_record?
        flash[:notice] = 'Contract was successfully created.'
        format.html { redirect_to(contract_url(@contract)) }
        format.xml  { render :xml => @contract, :status => :created, :location => @contract }
      else
        flash[:notice] = 'Contract was not successfully created.'
        logger.warn "Contract creation FAILED"
        format.html { redirect_to :action => "index" }
        format.xml  { render :xml => @contract.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  protected  
  def authorized?
    current_user.role >= IMPORT || not_authorized
  end

  def create_guid()
     t = Time.now
     a_dec = t.usec.to_s
     a_sec = t.to_i.to_s
     
     dec_hex = sprintf("%x", a_dec)
     sec_hex = sprintf("%x", a_sec)
     
     dec_hex = ensure_length(dec_hex,5)
     sec_hex = ensure_length(sec_hex,6)
     
     @guid = ""
     @guid << dec_hex
     @guid << create_guid_section(3)
     @guid << "-"
     @guid << create_guid_section(4)
     @guid << "-"
     @guid << create_guid_section(4)
     @guid << "-"
     @guid << create_guid_section(4)
     @guid << "-"
     @guid << sec_hex
     @guid << create_guid_section(6)
  
     return @guid
  end
  
  def ensure_length(str, len)
     strlen = str.length
     
     if strlen < len
        str = str + "000000"
        str = str[0,len]
     elsif strlen > len
        str = str[0,len]
     end
     
     return str
  end
  
  def create_guid_section(chars)
     @retval = ""
     
     chars.times do |i|
       @retval << sprintf("%x", rand(15))
     end
     return @retval
  end

  def set_dropdowns
    @currdate = Date.today
    @sugar_accts = SugarAcct.find(:all, :select => "concat(id, '|', name) as id, name", :conditions => "deleted = 0", :order => "name")
    @contracts = Contract.find(:all, :select => "id, concat(account_name,' | ',IF(LENGTH(said)>29,CONCAT(LEFT(said,30),'...'),said),' | ',start_date,' | ', IF(LENGTH(description)>29,CONCAT(LEFT(description,30),'...'),description)) as label", :order => 'account_name, said')
    @contract ||= params[:contract]
    @sales_reps = User.user_list
    @sales_offices =  SugarTeam.find(:all, :select => "concat(id, '|', name) as id, name", :conditions => "private = 0 AND deleted = 0 AND id <> 1", :order => "name")
    @support_offices = @sales_offices
    @pay_terms = Dropdown.payment_terms_list
    @platform = Dropdown.platform_list
    @types = SugarContractType.find(:all, :select => "id, name", :conditions => "deleted = 0", :order => "list_order")
  end
end
