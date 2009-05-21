class SwproductsController < ApplicationController
  before_filter :login_required
  before_filter :authorized?, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :get_swlist_whitelist
  before_filter :set_current_tab
=begin
  # GET /swproducts
  # GET /swproducts.xml
  def index
    @swproducts = Swproduct.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @swproducts }
    end
  end

  # GET /swproducts/1
  # GET /swproducts/1.xml
  def show
    @swproduct = Swproduct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @swproduct }
    end
  end
=end
  # GET /swproducts/new
  # GET /swproducts/new.xml
  def new
    @swproduct = @swlist_whitelist.swproducts.new
    logger.debug @swproduct
    @tier_choices ||= Swproduct.tier_choices
    logger.debug @tier_choices
    @license_types ||= Swproduct.license_types.invert
    logger.debug @license_types
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @swproduct }
    end
  end

  # GET /swproducts/1/edit
  def edit
    @swproduct = Swproduct.find(params[:id])
    @tier_choices ||= Swproduct.tier_choices
    @license_types = Swproduct.license_types.invert
  end

  # POST /swproducts
  # POST /swproducts.xml
  def create
    @swproduct = @swlist_whitelist.swproducts.new(params[:swproduct])
    @license_types ||= Swproduct.license_types.invert
    @tier_choices ||= Swproduct.tier_choices

    respond_to do |format|
      if @swproduct.save
        flash[:notice] = 'Swproduct was successfully created.'
        @swproduct = nil
        #format.html { render :action => "new" }
        format.html { redirect_to new_swlist_whitelist_swproduct_path(@swlist_whitelist) }
        format.xml  { render :xml => @swlist_whitelist, :status => :created, :location => @swlist_whitelist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @swproduct.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /swproducts/1
  # PUT /swproducts/1.xml
  def update
    @swproduct = Swproduct.find(params[:id])

    respond_to do |format|
      if @swproduct.update_attributes(params[:swproduct])
        flash[:notice] = 'Swproducts was successfully updated.'
        format.html { redirect_to(@swlist_whitelist) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @swproduct.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /swproducts/1
  # DELETE /swproducts/1.xml
  def destroy
    @swproduct = Swproduct.find(params[:id])
    @swproduct.destroy

    respond_to do |format|
      format.html { redirect_to(@swlist_whitelist) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def authorized?
    current_user.role == ADMIN || not_authorized
  end

  def get_swlist_whitelist
    @swlist_whitelist = SwlistWhitelist.find params[:swlist_whitelist_id]
  end

  def set_current_tab
    @current_tab = 'admin'
  end

end
