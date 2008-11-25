#require 'ruby-debug'
#TODO: Mass update feature for line_items
class LineItemsController < ApplicationController
  #TODO: Determine if login required
  before_filter :get_contract
  before_filter :login_required
  before_filter :authorized?, :only => [:new, :create, :edit, :update, :destroy]

=begin
  # GET /line_items
  # GET /line_items.xml
  def index
    logger.info "******* LineItems controller index method"
    @line_items = @contract.line_items.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @line_items }
    end
  end


# GET /line_items/1
  # GET /line_items/1.xml
  def show
    logger.info "******* LineItems controller show method"
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
    logger.info "******* LineItems controller new method"
    @line_item = @contract.line_items.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    logger.info "******* LineItems controller edit method"
    @line_item = @contract.line_items.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.xml
  def create
    logger.info "******* LineItems controller create method"
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
    logger.info "******* LineItems controller update method"
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
    logger.info "******* LineItems controller destroy method"
    
    @line_item = @contract.line_items.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to(@contract) }
      #format.xml  { head :ok }
    end
  end
  
  protected
  
  def get_contract
    @contract = Contract.find params[:contract_id]
  end
  
  def authorized?
    current_user.role == ADMIN || not_authorized
  end

end
