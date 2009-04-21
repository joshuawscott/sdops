class InventoryItemsController < ApplicationController
  before_filter :login_required
  before_filter :authorized?, :only => [:new, :create, :edit, :update, :destroy]

  # GET /inventory_items
  # GET /inventory_items.xml
  def index
    #@warehouses =  %w[A1 C1 D1 DL H1 I1 N1 ON P1 T1 U1 X1]
    #TODO: grab warehouses from ProDealer
    if params[:search] != nil
      #Get search criteria from params object
      @tracking ||= params[:search][:tracking]
      @item_code ||= params[:search][:item_code]
      @description ||= params[:search][:description]
      @serial_number ||= params[:search][:serial_number]
      @warehouse ||= params[:search][:warehouse]
      @location ||= params[:search][:location]
      #Create and set the scope conditions
      @inventory_items = InventoryItem.scoped({})
      @inventory_items = @inventory_items.conditions "inventory_items.id = ?", @tracking unless @tracking.blank?
      @inventory_items = @inventory_items.conditions "inventory_items.item_code = ?", @item_code unless @item_code.blank?
      @inventory_items = @inventory_items.conditions "inventory_items.description like ?", "%"+@description+"%" unless @description.blank?
      @inventory_items = @inventory_items.conditions "inventory_items.serial_number = ?", @serial_number unless @serial_number.blank?
      @inventory_items = @inventory_items.conditions "inventory_items.warehouse = ?", @warehouse unless @warehouse.blank?
      @inventory_items = @inventory_items.conditions "inventory_items.location = ?", @location unless @location.blank?
    else
      @inventory_items = InventoryItem.find(:all)
    end
    @locations = @inventory_items.map {|x| x.location}.uniq.sort
    @warehouses = @inventory_items.map {|x| x.warehouse}.uniq.sort
    respond_to do |format|
      store_location
      format.html { render :html => @inventory_items }# index.html.haml
      format.xml  { render :xml => @inventory_items }
      format.xls  #Respond as Excel Doc
    end
  end

  # GET /inventory_items/1
  # GET /inventory_items/1.xml
  def show
    @inventory_item = InventoryItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @inventory_item }
      format.xls  #Respond as Excel Doc
    end
  end

  # GET /inventory_items/new
  # GET /inventory_items/new.xml
  def new
    @inventory_item = InventoryItem.new
   
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @inventory_item }
    end
  end

  # GET /inventory_items/1/edit
  def edit
    @inventory_item = InventoryItem.find(params[:id])

  end

  # POST /inventory_items
  # POST /inventory_items.xml
  def create
    logger.debug "******* InventoryItems controller create method"
    @inventory_item = InventoryItem.new(params[:inventory_item])

    respond_to do |format|
      if @inventory_item.save
        flash[:notice] = 'InventoryItem was successfully created.'
        format.html { redirect_to(@inventory_item) }
        format.xml  { render :xml => @inventory_item, :status => :created, :location => @inventory_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @inventory_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /inventory_items/1
  # PUT /inventory_items/1.xml
  def update
    @inventory_item = InventoryItem.find(params[:id])

    respond_to do |format|
      if @inventory_item.update_attributes(params[:inventory_item])
        flash[:notice] = 'InventoryItem was successfully updated.'
        format.html { redirect_to(@inventory_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @inventory_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_items/1
  # DELETE /inventory_items/1.xml
  def destroy
    @inventory_item = InventoryItem.find(params[:id])
    @inventory_item.destroy

    respond_to do |format|
      format.html { redirect_to(inventory_items_url) }
      format.xml  { head :ok }
    end
  end

  protected
  def authorized?
    current_user.role == ADMIN || not_authorized
  end

	def manager?
		current_user.role >= MANAGER || not_manager
	end
end
