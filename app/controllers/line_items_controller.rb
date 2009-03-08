#require 'ruby-debug'
class LineItemsController < ApplicationController
  #TODO: Determine if login required
  before_filter :get_contract
  before_filter :login_required
  before_filter :authorized?, :only => [:new, :create, :edit, :update, :destroy, :mass_update]

=begin
  # GET /line_items
  # GET /line_items.xml
  def index
    logger.debug "******* LineItems controller index method"
    @line_items = @contract.line_items.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @line_items }
    end
  end


# GET /line_items/1
  # GET /line_items/1.xml
  def show
    logger.debug "******* LineItems controller show method"
    @line_item = @contract.line_items.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @line_item }
    end
  end

=end

  # GET /line_items/new
  # GET /line_items/new.xml
  def new
    #TODO: JS to Pull description/list price from support price db?
    #TODO: Dropdowns for new/edit form
    logger.debug "******* LineItems controller new method"
    @line_item = @contract.line_items.new
    #set defaults for 'new' form:
    @line_item.support_provider = 'Sourcedirect'
    @line_item.location = @contract.support_office_name
    @line_item.begins = @contract.start_date
    @line_item.ends = @contract.end_date
    @support_providers = Dropdown.support_provider_list

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    logger.debug "******* LineItems controller edit method"
    @line_item = @contract.line_items.find(params[:id])
    @support_providers = Dropdown.support_provider_list
  end

  # POST /line_items
  # POST /line_items.xml
  def create
    logger.debug "******* LineItems controller create method"
    @line_item = @contract.line_items.new(params[:line_item])

    @line_item.contract_id = params[:contract_id]

    respond_to do |format|
      if @line_item.save
        flash[:notice] = 'Line Item was successfully created.'
        format.html { redirect_to(@contract) }
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
    @line_item = @contract.line_items.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        flash[:notice] = 'Line Item was successfully updated.'
        format.html { redirect_to(@contract) }
        #format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        #format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.xml
  def destroy
    logger.debug "******* LineItems controller destroy method"
    @line_item = @contract.line_items.find(params[:id])
		logger.info current_user.login + " destroyed line item " + @line_item.id.to_s
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to(@contract) }
      #format.xml  { head :ok }
    end
  end
  
  # PUT /line_items/mass_update
	def mass_update
		logger.debug "******* LineItems controller mass_update method"
		unless params[:line_item_ids].nil?
			@line_items = @contract.line_items.find(params[:line_item_ids])
			for x in @line_items do
				x.support_provider = params[:support_provider] unless params[:support_provider] == ""
				x.location = params[:location] unless params[:location] == ""
				x.begins = params[:begins] unless params[:begins] == ""
				x.ends = params[:ends] unless params[:ends] == ""
				if x.save
					logger.debug "Succesfully performed line items mass update"
				  flash[:notice] = "Mass update successful."
				else
					logger.error "*******************************"
					logger.error "*line_items mass update failed*"
					logger.error "*******************************"
					flash[:error] = "Mass update failed"
				end
			end
		end
		redirect_to contract_path(@contract)
	end
  protected
  
  def get_contract
    @contract = Contract.find params[:contract_id]
  end
  
  def authorized?
    current_user.role == ADMIN || not_authorized
  end

end
