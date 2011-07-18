class LineItemsController < ApplicationController
  before_filter :get_contract, :except => [:form_pull_pn_data, :sort]
  before_filter :authorized?, :only => [:sort, :new, :create, :edit, :update, :mass_update]
  before_filter :set_dropdowns, :only => [:new, :edit, :create, :update]
  before_filter :admin?, :only => [:destroy]

  def show
    @line_item = LineItem.find params[:id]
  end
  # GET /line_items/new
  # GET /line_items/new.xml
  def new
    logger.debug "******* LineItems controller new method"
    last_position = LineItem.find(:last, :conditions => {:support_deal_id => @support_deal.id}, :order => "position ASC").position unless @support_deal.line_items.size == 0
    @line_item = @support_deal.line_items.new(:support_provider => 'Sourcedirect',
      :location => @support_deal.support_office_name,
      :begins => @support_deal.start_date,
      :ends => @support_deal.end_date,
      :position => (last_position || 0) + 1,
      :support_type => params[:support_type]
      )

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    logger.debug "******* LineItems controller edit method"
    @line_item = @support_deal.line_items.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def form_pull_pn_data
    @new_info = LineItem.new(params[:line_item] || {:product_num => params[:product_num], :support_type => params[:support_type], :support_deal_id => params[:support_deal_id]}).return_current_info
  end

  # POST /line_items
  # POST /line_items.xml
  def create
    logger.debug "******* LineItems controller create method"
    @line_item = @support_deal.line_items.new(params[:line_item])
    @line_item.support_deal_id = params[:contract_id]

    respond_to do |format|
      if @line_item.save
        flash[:notice] = 'Line Item was successfully created.'
        format.html { redirect_to(@support_deal) }
        #format.xml  { render :xml => @line_item, :status => :created, :location => @line_item }
      else
        format.html { render :action => "new" }
        #format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.xml
  def update
    logger.debug "******* LineItems controller update method"
    @line_item = @support_deal.line_items.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        flash[:notice] = 'Line Item was successfully updated.'
        format.html { redirect_to(@support_deal) }
        #format.xml  { head :ok }
        # returns the updated attribute, if you are updating just one (this is to handle click-to-edit)
        format.js {
          key = nil
          params[:line_item].each {|k,v| key = k}
          render :text => @line_item.send("#{key}")
          }
      else
        format.html { render :action => "edit" }
        #format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
        format.js { render :text => "ERROR"}
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.xml
  def destroy
    logger.debug "******* LineItems controller destroy method"
    @line_item = @support_deal.line_items.find(params[:id])
		logger.info current_user.login + " destroyed line item " + @line_item.id.to_s
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to(@support_deal) }
      #format.xml  { head :ok }
    end
  end

  # PUT /line_items/mass_update
	def mass_update
		#TODO: check filtering based on submit button clicked.
    logger.debug "******* LineItems controller mass_update method"
    line_item_ids = params[:HW_line_item_ids].to_a + params[:SW_line_item_ids].to_a + params[:SRV_line_item_ids].to_a
    unless line_item_ids.nil? || line_item_ids.empty?
      @line_items = @support_deal.line_items.find(line_item_ids)
			if params[:commit] == "Delete Checked Items"
			  if current_user.has_role?(:admin)
			    @line_items.each {|line| line.destroy}
			  else
			    flash[:error] = "You are not authorized to perform that action"
			  end
			elsif params[:commit] == "Add to Subcontract"
        @subcontractors = Subcontractor.find(:all)
        render(:action => "add_to_subcontract") and return
      else
        updated_count = 0
        failed_count = 0
			  @line_items.each do |x|
			  	x.support_provider = params[:support_provider] unless params[:support_provider] == ""
			  	x.location = params[:location] unless params[:location] == ""
			  	x.begins = params[:begins] unless params[:begins] == ""
			  	x.ends = params[:ends] unless params[:ends] == ""
          if x.save
			  		logger.debug "Succesfully performed line items mass update"
			  	  updated_count += 1
            flash[:notice] = "Successfully updated " + updated_count.to_s + " line items"
          else
            failed_count += 1
			  		logger.error "*******************************"
			  		logger.error "*line_items mass update failed*"
			  		logger.error "*******************************"
			  		flash[:error] = "Failed to update " + failed_count.to_s + " line items"
          end
        end
			end
    end
    if params[:commit] == "Update Positions"
      #raise
      line_items = params[:HW_line_items].to_a + params[:SW_line_items].to_a + params[:SRV_line_items].to_a
      line_items.each do |line_item|
        line_to_update = LineItem.find(line_item[:id])
        line_to_update.update_attribute(:position, line_item[:position])
      end
    end
		redirect_to contract_path(@support_deal)
	end

  def sort
    sorted_type = params[:hwlines].nil? ? "SW" : "HW"
    sorted_table = sorted_type == 'HW' ? 'hwlines' : 'swlines'
    @line_items = LineItem.find(:all, :conditions => {:support_deal_id => params[:id], :support_type => sorted_type}, :order => 'position ASC')
    @line_items.each do |line_item|
      line_item.position = params[sorted_table].index(line_item.id.to_s)
      line_item.save(false)
    end
    render :nothing => true
  end
  protected

  def get_contract
    @support_deal = SupportDeal.find params[:contract_id] if params[:contract_id]
    @support_deal ||= LineItem.find(params[:id]).support_deal
  end

  def authorized?
    current_user.has_role?(:admin, :contract_admin, :contract_editor) || not_authorized
  end

  def admin?
    current_user.has_role?(:admin) || not_authorized
  end

  def set_dropdowns
    @support_providers = Subcontractor.find(:all).map {|s| s.name}
    @support_providers.insert 0, "Sourcedirect"
    @support_types = LineItem.support_types
  end

end
