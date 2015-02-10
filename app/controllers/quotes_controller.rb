class QuotesController < ApplicationController
  before_filter :authorized?, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :set_dropdowns, :only => [:new, :edit, :create, :update]

  # GET /quotes
  # GET /quotes.xml
  def index
    @quotes = Quote.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @quotes }
    end
  end

  # GET /quotes/1
  # GET /quotes/1.xml
  def show
    @quote = Quote.find(params[:id])
    @comments = @quote.comments.sort { |x, y| y.created_at <=> x.created_at }
    @comment = Comment.new
    @line_items = @quote.line_items.sort_by { |x| x.position }
    @hwlines = @line_items.find_all { |e| e.support_type == "HW" }
    @swlines = @line_items.find_all { |e| e.support_type == "SW" }
    @srvlines = @line_items.find_all { |e| e.support_type == "SRV" }
    @support_providers = Subcontractor.find(:all, :select => :name).map { |s| s.name }
    @support_providers.insert 0, "Sourcedirect"
    @sales_rep = User.find(@quote.sales_rep_id, :select => "first_name, last_name").full_name
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @quote }
      format.json { render :json => @quote }
    end
  end

  # GET /quotes/new
  # GET /quotes/new.xml
  def new
    # Quote defaults
    @quote = Quote.new(:discount_pref_hw => 0.0,
                       :discount_pref_sw => 0.0,
                       :discount_pref_srv => 0.0,
                       :discount_prepay => 0.04,
                       :discount_multiyear => 0.0,
                       :discount_ce_day => 0.0,
                       :discount_sa_day => 0.0
    )
    @replaces = []
    @replaced_by = []

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @quote }
    end
  end

  # GET /quotes/1/edit
  def edit
    @quote = Quote.find(params[:id])
    #@replaces = Quote.find(:all, :conditions => "account_name = '#{@quote.account_name.gsub(/\\/, '\&\&').gsub(/'/, "''")}' AND id <> #{params[:id]} AND start_date <= '#{@quote.start_date}'")
    #@replaced_by = Quote.find(:all, :conditions => "account_name = '#{@quote.account_name.gsub(/\\/, '\&\&').gsub(/'/, "''")}' AND id <> #{params[:id]} AND end_date >= '#{@quote.end_date}'")

  end

  # POST /quotes
  # POST /quotes.xml
  def create
    @quote = Quote.new(params[:quote])

    respond_to do |format|
      if @quote.save
        flash[:notice] = 'Quote was successfully created.'
        format.html { redirect_to(@quote) }
        format.xml { render :xml => @quote, :status => :created, :location => @quote }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @quote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quotes/1
  # PUT /quotes/1.xml
  def update
    @quote = Quote.find(params[:id])
    # Preserve the NULL values to make sure we can separate the old quotes
    # that have no RMM/MBS from the new quotes where a customer may decline.
    unless params[:quote].blank?
      params[:quote][:basic_backup_auditing] = nil if params[:quote][:basic_backup_auditing] == ""
      params[:quote][:basic_remote_monitoring] = nil if params[:quote][:basic_remote_monitoring] == ""
    end

    respond_to do |format|
      if @quote.update_attributes(params[:quote])
        flash[:notice] = 'Quote was successfully updated.'
        format.html { redirect_to(@quote) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @quote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.xml
  def destroy
    @quote = Quote.find(params[:id])
    @quote.destroy

    respond_to do |format|
      format.html { redirect_to(quotes_url) }
      format.xml { head :ok }
    end
  end

  def quote
    response.headers['Expires'] = '0'
    response.headers['Cache-Control'] = 'private'
    response.headers['Pragma'] = 'Cache'
    #expires_in 120, :private => true, :must-revalidate => nil
    @contract = Quote.find(params[:id])
    @line_items = LineItem.find(:all, :conditions => {:support_deal_id => params[:id]})
    @hw_line_items = @contract.hw_line_items
    @sw_line_items = @contract.sw_line_items
    @srv_line_items = @contract.srv_line_items
    @hw_list_price = @contract.hw_list_price
    @sw_list_price = @contract.sw_list_price
    @srv_list_price = @contract.srv_list_price
    multiyear = @contract.discount_multiyear > 0.0
    prepay = true
    @best_discount_amount = @contract.discount_amount(:type => :hw, :prepay => prepay, :multiyear => multiyear) + @contract.discount_amount(:type => :sw, :prepay => prepay, :multiyear => multiyear) + @contract.discount_amount(:type => :srv, :prepay => prepay, :multiyear => multiyear)
    prawnto :prawn => {:page_layout => :landscape}, :inline => false
  end

  protected
  def authorized?
    current_user.has_role?(:admin, :contract_admin, :quoter) || not_authorized
  end

  def set_dropdowns
    @sugar_accts = SugarAcct.find(:all, :select => "id, name", :conditions => "deleted = 0", :order => "name")
    @sales_offices = SugarTeam.dropdown_list(current_user.sugar_team_ids)
    @support_offices = @sales_offices
    @pay_terms = Dropdown.payment_terms_list
    @platform = Dropdown.platform_list
    @reps = User.user_list
    @primary_ces = @reps
    @types_hw = Dropdown.support_type_list_hw
    @types_sw = Dropdown.support_type_list_sw
  end
end
