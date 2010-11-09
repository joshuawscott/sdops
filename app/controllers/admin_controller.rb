class AdminController < ApplicationController
  before_filter :authorized?
  
  # GET /admin
  def index
  
    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # GET /admin/appgen
  def appgen
    #debugger
    if params[:appgen] != nil
      @appgen = Appgen.new(params[:appgen])
      @delimited = params[:appgen][:delimited]
      @dir = params[:appgen][:dir]
      @table = params[:appgen][:table]
      @mv_field_count = params[:appgen][:mv_field_count]
      @out_file = params[:appgen][:out_file]
      @sort_str = params[:appgen][:sort_str]
      @filters = params[:appgen][:filters]
      @fields = params[:appgen][:fields]
      @query = @appgen.query
      @results = @appgen.get_data
    end
    @fields.gsub!(/\|/, " ") if params[:appgen] != nil
    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # GET /admin/lineitems
  def lineitems
    @contracts = Contract.find_by_sql("select c.id, c.account_name, c.description, c.end_date, count(l.id) as line_items FROM `support_deals` c left join line_items as l on c.id = l.support_deal_id where c.expired <> true group by c.id having count(l.id) = 0 ORDER BY c.end_date DESC, c.account_name, c.description")

    respond_to do |format|
      format.html # lineitems.html.haml
    end
  end
  
  # GET /admin/account_id
  def account_id
    @contracts = Contract.find(:all, :conditions => 'CHAR_LENGTH(account_id) < 2', :order => 'account_name, start_date')

    respond_to do |format|
      format.html # account_id.html.haml
    end
  end
  
  # GET /admin/cashflow
  def cashflow
    @contracts = Contract.find(:all, :conditions => 'expired <> true', :include => :predecessors, :order => 'end_date, account_name')

    respond_to do |format|
      format.html # cashflow.html.haml
    end
  end

  def jared
    respond_to do |format|
      format.html
      format.xls do
        first_id = params[:first_id].to_i
        last_id = params[:last_id].to_i == 0 ? Contract.find(:last).id.to_i : params[:last_id].to_i
        @contracts = Contract.find(:all, :conditions => ["id >= ? AND id <= ?", first_id, last_id] )
      end
    end
  end

  def missing_manufacturer
    @hw_products = HwSupportPrice.find(:all, :conditions => "manufacturer_line_id IS NULL OR manufacturer_line_id = ''")
    @sw_products = SwSupportPrice.find(:all, :conditions => "manufacturer_line_id IS NULL OR manufacturer_line_id = ''")
  end

  def tlci
    @hw_products = HwSupportPrice.find(:all, :conditions => "tlci IS NULL AND list_price > 0", :order => "part_number ASC")
    @sw_products = SwSupportPrice.find(:all, :conditions => "tlci IS NULL AND phone_price + update_price > 0", :order => "part_number ASC")
  end
  protected
  def authorized?
    current_user.has_role?(:admin) || not_authorized
  end

end
