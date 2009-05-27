class UpfrontOrdersController < ApplicationController
  before_filter :set_dropdowns, :only => [:review_import, :save_import]
  before_filter :authorized?
  def index
    @upfront_orders = UpfrontOrder.find(:all, :joins => :appgen_order, :order => :ship_date)
    
  end
  def show
    @upfront_order = UpfrontOrder.find(params[:id], :include => :appgen_order)
    @lineitems = AppgenOrderLineitem.find(:all, :include => :appgen_order_serial, :conditions => ['appgen_order_id = ?', @upfront_order.appgen_order_id])
  end

  def edit
    @upfront_order = UpfrontOrder.find(params[:id])
    @appgen_order = @upfront_order.appgen_order
  end
  def update_from_appgen
    UpfrontOrder.update_from_appgen
    redirect_to upfront_orders_url
  end

  def update
    #raise
    @upfront_order = UpfrontOrder.find(params[:id])

    respond_to do |format|
      if @upfront_order.update_attributes(params[:upfront_order])
        flash[:notice] = 'Upfront Order was successfully updated.'
        format.html { redirect_to(@upfront_order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @upfront_order.errors, :status => :unprocessable_entity }
      end
    end

  end
  
  def review_import
    @contracts = Contract.find(:all)
    @upfront_order = UpfrontOrder.find(params[:id])
    @appgen_order = @upfront_order.appgen_order
    @appgen_order_lineitems = @appgen_order.appgen_order_lineitems
    @support_revenue_lines = []
    @srltotal = BigDecimal.new("0.0")
    @appgen_order_lineitems.each do |a|
      if a.part_number.match(/^SDC/)
        @support_revenue_lines << a
        @srltotal += a.price
      end
    end
  end

  def save_import
    @upfront_order = UpfrontOrder.find(params[:id])
    @appgen_order = @upfront_order.appgen_order
    contract_hash = {
      :said => @upfront_order.appgen_order_id,
      :sdc_ref => @upfront_order.appgen_order_id,
      :cust_po_num => @appgen_order.cust_po_number,
      :payment_terms => "Bundled",
      :start_date => @appgen_order.ship_date + 1,
      :expired => false,
      :updates => true,
      :discount_pref_hw => 0.0,
      :discount_pref_sw => 0.0,
      :discount_pref_srv => 0.0,
      :discount_prepay => 0.0,
      :discount_multiyear => 0.0,
      :discount_ce_day => 0.0,
      :discount_sa_day => 0.0,
      :so_number => @upfront_order.appgen_order_id,
      :po_received => @appgen_order.ship_date}
      @contract = Contract.new(contract_hash.merge(params[:contract]))
    if @contract.save
      flash[:notice] = "Contract Created"
      @contract.reload
      @upfront_order.contract_id = @contract.id
      @upfront_order.completed = true
      @upfront_order.save
      line_item_hash = {
        :contract_id => @contract.id,
        :begins => @contract.start_date,
        :ends => @contract.end_date,
        :location => @contract.support_office_name,
        :support_provider => 'Sourcedirect'}
      position = 1
      params[:line_item].each do |l|
        if l[:is_hw] == "true"
          currinfo = SupportPriceHw.current_list_price(l[:product_num])
          l[:list_price] = currinfo.list_price
          l[:description] = currinfo.description
          l[:support_type] = 'HW'
          l[:position] = position
          line_item_hash.merge!(l)
          line_item_hash.delete("is_hw")
          line_item_hash.delete("is_sw")
          line_item_hash.delete(:is_hw)
          line_item_hash.delete(:is_sw)
          @line_item = LineItem.new(line_item_hash)
          @line_item.save
          position += 1
        end
      end
      position = 1
      params[:line_item].each do |l|
        if l[:is_sw] == "true"
          currinfo = SupportPriceSw.current_list_price(l[:product_num])
          l[:list_price] = currinfo.list_price
          l[:description] = currinfo.description
          l[:support_type] = 'SW'
          l[:position] = position
          line_item_hash.merge!(l)
          line_item_hash.delete("is_hw")
          line_item_hash.delete("is_sw")
          line_item_hash.delete(:is_hw)
          line_item_hash.delete(:is_sw)
          @line_item = LineItem.new(line_item_hash)
          @line_item.save
          position += 1
        end
      end
      redirect_to contract_path(@contract)
    else
      flash[:error] = "Contract Creation Failed!"
      redirect_to review_import_upfront_order_path(@upfront_order) and return
    end

  end

  protected
  def set_dropdowns
    #Contract dropdowns
    @sugar_accts = SugarAcct.find(:all, :select => "id, name", :conditions => "deleted = 0", :order => "name")
    @sales_offices =  SugarTeam.dropdown_list(current_user.role, current_user.sugar_team_ids)
    @support_offices = @sales_offices
    @pay_terms = Dropdown.payment_terms_list
    @platform = Dropdown.platform_list
    @reps = User.user_list
    @types_hw = Dropdown.support_type_list_hw
    @types_sw = Dropdown.support_type_list_sw
    @contract_types = SugarContractType.find(:all, :select => "id, name", :conditions => "deleted = 0 AND name LIKE 'Support - Bundled%'", :order => "list_order")
    #LineItem dropdowns
    @support_providers = Dropdown.support_provider_list
  end
    
  def authorized?
    if logged_in? && current_user.role == ADMIN
       true
    else
       not_authorized
    end
  end

  
end
