class UpfrontOrdersController < ApplicationController
  before_filter :set_dropdowns, :only => [:review_import, :save_import]
  before_filter :authorized?, :except => [:show, :index]
  before_filter :read_authorized?, :only => [:show, :index]
  def index
    #@upfront_orders = UpfrontOrder.find(:all, :joins => :appgen_order, :order => :ship_date)
    @upfront_orders = UpfrontOrder.find(:all, :conditions => "completed = 0 AND has_upfront_support = 1", :order => :id)
  end
  def show
    #@upfront_order = UpfrontOrder.find(params[:id], :include => :appgen_order)
    #@lineitems = AppgenOrderLineitem.find(:all, :include => :appgen_order_serial, :conditions => ['appgen_order_id = ?', @upfront_order.appgen_order_id])
    @upfront_order = UpfrontOrder.find(params[:id])
    @lineitems = @upfront_order.linked_order.line_items
  end

  def edit
    @upfront_order = UpfrontOrder.find(params[:id])
    @linked_order = @upfront_order.linked_order
    @line_items = @upfront_order.linked_order.line_items
    @contract_dropdown = Contract.find(:all, :conditions => {:payment_terms => "Bundled"}).collect {|c| [c.said.to_s + " | " + c.description.to_s, c.id]}
  end
  def update_from_appgen
    UpfrontOrder.update_from_appgen
    redirect_to upfront_orders_url
  end
  def update_from_fishbowl
    UpfrontOrder.update_from_fishbowl
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
    @contracts = Contract.find(:all, :conditions => {:expired => false})
    @upfront_order = UpfrontOrder.find(params[:id])
    @linked_order = @upfront_order.linked_order
    if @linked_order.class == AppgenOrder
      @lineitems = AppgenOrderLineitem.find(:all, :conditions => {:appgen_order_id => @linked_order.id}, :include => :appgen_order_serial)
    elsif @linked_order.class == FishbowlSo
      @lineitems = @linked_order.line_items
      rep_selected = User.find(:first, :conditions => ["login = ?", @linked_order.salesman])
      @rep_selected_id = rep_selected.id unless rep_selected.nil?
      office_selected = SugarTeam.find(:first, :conditions => {:name => @linked_order.team_name})
      @office_selected_id = office_selected.id unless office_selected.nil?
      @office_selected_name = office_selected.name unless office_selected.nil?
      #Find matching contracts
      matching_accounts = SugarAcct.find(:all, :conditions => {:deleted => false, :name => @linked_order.customer_name})
      if matching_accounts.length == 1
        @account_selected_id = matching_accounts[0].id
        @account_selected_name = matching_accounts[0].name
      end
    end
    @support_revenue_lines = []
    @srltotal = BigDecimal.new("0.0")
    @lineitems.each do |lineitem|
      if lineitem.part_number.match(/^SDC/)
        @support_revenue_lines << lineitem
        @srltotal += lineitem.price
      end
    end
  end

  def save_import
    @upfront_order = UpfrontOrder.find(params[:id])
    @linked_order = @upfront_order.linked_order
    #defaults - these are overridden by the user input.
    contract_hash = {
      :said => @linked_order.num,
      :sdc_ref => @linked_order.num,
      :cust_po_num => @linked_order.cust_po_number,
      :payment_terms => "Bundled",
      :start_date => @linked_order.ship_date + 1,
      :expired => false,
      :discount_pref_hw => 0.0,
      :discount_pref_sw => 0.0,
      :discount_pref_srv => 0.0,
      :discount_prepay => 0.0,
      :discount_multiyear => 0.0,
      :discount_ce_day => 0.0,
      :discount_sa_day => 0.0,
      :so_number => @linked_order.num,
      :po_received => @linked_order.ship_date}
    @contract = Contract.new(contract_hash.merge(params[:contract]))
    if @contract.save
      flash[:notice] = "Contract Created"
      @contract.reload
      @upfront_order.support_deal_id = @contract.id
      @upfront_order.completed = true
      @upfront_order.save
      line_item_hash = {
        :support_deal_id => @contract.id,
        :begins => @contract.start_date,
        :ends => @contract.end_date,
        :location => @contract.support_office_name,
        :support_provider => 'Sourcedirect'}
      position = 1
      params[:line_item].each do |l|
        if l[:is_hw] == "true"
          currinfo = HwSupportPrice.current_list_price(l[:product_num])
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
          currinfo = SwSupportPrice.current_list_price(l[:product_num])
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
  # Set Contract dropdowns - these are used in several forms.
  def set_dropdowns
    @sugar_accts = SugarAcct.find(:all, :select => "id, name", :conditions => "deleted = 0", :order => "name")
    @sales_offices = SugarTeam.dropdown_list(current_user.sugar_team_ids)
    @support_offices = @sales_offices
    @pay_terms = Dropdown.payment_terms_list
    @platform = Dropdown.platform_list
    @reps = User.user_list
    @types_hw = Dropdown.support_type_list_hw
    @types_sw = Dropdown.support_type_list_sw
    #LineItem dropdowns
    #@support_providers = Dropdown.support_provider_list
    @support_providers = Subcontractor.find(:all)
    @support_providers << Subcontractor.new(:id => 0, :name => "Sourcedirect")
  end
    
  def authorized?
    current_user.has_role?(:admin) || not_authorized
  end

  def read_authorized?
    current_user.has_role?(:admin, :hardware_sales) || not_authorized
  end
end
