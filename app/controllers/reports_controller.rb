class ReportsController < ApplicationController
  before_filter :login_required

  # GET /reports
  def index
    #@accounts = list_accounts
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  
  
  def list_accounts
    require 'soap/wsdlDriver'
    require 'digest/md5'
    u = "tnini"
    p = Digest::MD5.hexdigest("C0l02%8")
    ua = {"user_name" => u,"password" => p}
    wsdl = "http://crm1.sourcedirect.com/soap.php?wsdl"

    #create soap
    s = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver

    #uncomment this line for debugging. saves xml packets to files
    #s.wiredump_file_base = "soapresult"

    #create session
    ss = s.login(ua,nil)

    #check for login errors
    if ss.error.number.to_i != 0 

    	#status message
    	logger.debug "failed to login - #{ss.error.description}"

    	#exit program
    	exit

    else

    	#get id
    	sid = ss['id']

    	#get current user id
    	uid = s.get_user_id(sid)

    	#status message
    	logger.debug "logged in to session #{sid} as #{u} (#{uid})"

         #the part below is general. you can use it to get any type of data you want. just change the "module_name"

         module_name = "Opportunities"

         query = "opportunities.name like '%rp5470%'" # gets all the acounts, you can also use SQL like "accounts.name like '%company%'"
         order_by = "" # in default order. you can also use SQL like "accounts.name"
         offset = 0 # I guess this is like the SQL offset
         select_fields = ['name','amount'] # this can't be an empty array, my testing showed
         max_results = "1000000" # if set to 0 or "", this doesn't return all the results, like you'd expect
         deleted = 0 # whether you want to retrieve deleted records, too

         result = s.get_entry_list(sid,module_name,query,order_by,offset,select_fields,max_results,deleted)

         #below is where we build the array of names. note that everything gets returns in a name-value pairs hash (name_value_list), using the field list from the request

         @output = []
         for entry in result.entry_list
            item = {}
            for name_value in entry.name_value_list
              item[name_value.name]=name_value.value
            end
           @output << item
         end
      return @output
    	#logout
    	s.logout(sid)

    	#status message
    	logger.debug "logged out"
      
    end
  end
end
