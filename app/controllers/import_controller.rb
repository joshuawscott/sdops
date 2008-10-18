class ImportController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :authorized?, :only => [:new, :create, :edit, :update, :destroy]
  
  # GET /import
  def index
    @sugar_accts = SugarAcct.find(:all, :select => "concat(id, '|', name) as id, name", :conditions => "deleted = 0", :order => "name")
    @contracts = Contract.find(:all, :select => "id, concat(account_name,' | ',said,' | ',start_date,' | ',description) as label", :conditions => ["start_date <= ? AND end_date >= ?", Date.today, Date.today], :order => 'account_name, said')
    @sales_reps = User.user_list
    @sales_offices =  SugarTeam.find(:all, :select => "concat(id, '|', name) as id, name", :conditions => "private = 0 AND deleted = 0 AND id <> 1", :order => "name")
    @support_offices = @sales_offices
    @pay_terms = Dropdown.payment_terms_list
    @platform = Dropdown.platform_list
    @types = SugarContractType.find(:all, :select => "id, name", :conditions => "deleted = 0", :order => "list_order")
    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # POST /import
  def create()
    records = YAML::load( params[:importfile] )
    #Separate out the data

    contract_ary = records[0]
    line_items_ary = records[1..-1]
    aryAcct = params[:account_id].split('|')
    arySales = params[:sales_office].split('|')
    arySupport = params[:support_office].split('|')
    options = {'account_id' => aryAcct[0], 'account_name' => aryAcct[1], 'sales_rep_id' => params[:sales_rep_id], 'sales_office' => arySales[0], 'sales_office_name' => arySales[1], 'support_office' => arySupport[0], 'support_office_name' => arySupport[1], 'platform' => params[:platform], 'contract_type' => params[:contract_type]}
    contract_ary.ivars['attributes'].update(options)

    #Cleanup
    records = nil

    #Save new contract
    if params[:contract] != ""
      @contract = Contract.find(params[:contract])
      @contract.hw_support_level_id = contract_ary.ivars['attributes']['hw_support_level_id']
      @contract.sw_support_level_id = contract_ary.ivars['attributes']['sw_support_level_id']
      @contract.updates = contract_ary.ivars['attributes']['updates']
      @contract.said = contract_ary.ivars['attributes']['said']
    else
      @contract = Contract.new(contract_ary.ivars['attributes'])
    end

    #if Contract successfully saves then import
    #associated line items
    if @contract.save
      line_items_ary.each do |item|
        @line_item = @contract.line_items.new(item.ivars['attributes'])
        @line_item.save
      end
    end
    
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
    sugar_con.description = "https://sdops/contracts/#{@contract.id}\n" + "#{@contract.cust_po_num}\n"
    sugar_con.assigned_user_id = User.find(@contract.sales_rep_id).sugar_id
    sugar_con.created_by = @contract.sales_rep_id
    sugar_con.date_entered = DateTime.now
    sugar_con.date_modified = DateTime.now
    sugar_con.modified_user_id = @contract.sales_rep_id
    sugar_con.team_id = @contract.sales_office
    sugar_con.type = @contract.contract_type
    
    if sugar_con.save == false
      flash[:error] = "Sugar Contract was not created"
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
end
