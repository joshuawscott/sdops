class SwlistWhitelistsController < ApplicationController
  # GET /swlist_whitelists
  # GET /swlist_whitelists.xml
  def index
    @swlist_whitelists = SwlistWhitelist.find(:all)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @swlist_whitelists }
    end
  end

  # GET /swlist_whitelists/1
  # GET /swlist_whitelists/1.xml
  def show
    @swlist_whitelist = SwlistWhitelist.find(params[:id])
    translate = Swproduct.license_types
    @swlist_whitelist.swproducts.each do |swproduct|
      swproduct.license_type = translate[swproduct.license_type]
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @swlist_whitelist }
    end
  end

  # GET /swlist_whitelists/new
  # GET /swlist_whitelists/new.xml
  def new
    @swlist_whitelist = SwlistWhitelist.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @swlist_whitelist }
    end
  end

  # GET /swlist_whitelists/1/edit
  def edit
    @swlist_whitelist = SwlistWhitelist.find(params[:id])
  end

  # POST /swlist_whitelists
  # POST /swlist_whitelists.xml
  def create
    @swlist_whitelist = SwlistWhitelist.new(params[:swlist_whitelist])

    respond_to do |format|
      if @swlist_whitelist.save
        flash[:notice] = 'SwlistWhitelist was successfully created.'
        format.html { redirect_to(@swlist_whitelist) }
        format.xml  { render :xml => @swlist_whitelist, :status => :created, :location => @swlist_whitelist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @swlist_whitelist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /swlist_whitelists/1
  # PUT /swlist_whitelists/1.xml
  def update
    @swlist_whitelist = SwlistWhitelist.find(params[:id])

    respond_to do |format|
      if @swlist_whitelist.update_attributes(params[:swlist_whitelist])
        flash[:notice] = 'SwlistWhitelist was successfully updated.'
        format.html { redirect_to(@swlist_whitelist) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @swlist_whitelist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /swlist_whitelists/1
  # DELETE /swlist_whitelists/1.xml
  def destroy
    @swlist_whitelist = SwlistWhitelist.find(params[:id])
    @swlist_whitelist.destroy

    respond_to do |format|
      format.html { redirect_to(swlist_whitelists_url) }
      format.xml  { head :ok }
    end
  end
  

end
