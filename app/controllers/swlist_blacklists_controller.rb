class SwlistBlacklistsController < ApplicationController
  # GET /swlist_blacklists
  # GET /swlist_blacklists.xml
  def index
    @swlist_blacklists = SwlistBlacklist.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @swlist_blacklists }
    end
  end

  # GET /swlist_blacklists/1
  # GET /swlist_blacklists/1.xml
  def show
    @swlist_blacklist = SwlistBlacklist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @swlist_blacklist }
    end
  end

  # GET /swlist_blacklists/new
  # GET /swlist_blacklists/new.xml
  def new
    @swlist_blacklist = SwlistBlacklist.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @swlist_blacklist }
    end
  end

  # GET /swlist_blacklists/1/edit
  def edit
    @swlist_blacklist = SwlistBlacklist.find(params[:id])
  end

  # POST /swlist_blacklists
  # POST /swlist_blacklists.xml
  def create
    @swlist_blacklist = SwlistBlacklist.new(params[:swlist_blacklist])

    respond_to do |format|
      if @swlist_blacklist.save
        flash[:notice] = 'SwlistBlacklist was successfully created.'
        format.html { redirect_to :action => :new }
        format.xml  { render :xml => @swlist_blacklist, :status => :created, :location => @swlist_blacklist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @swlist_blacklist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /swlist_blacklists/1
  # PUT /swlist_blacklists/1.xml
  def update
    @swlist_blacklist = SwlistBlacklist.find(params[:id])

    respond_to do |format|
      if @swlist_blacklist.update_attributes(params[:swlist_blacklist])
        flash[:notice] = 'SwlistBlacklist was successfully updated.'
        format.html { redirect_to(@swlist_blacklist) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @swlist_blacklist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /swlist_blacklists/1
  # DELETE /swlist_blacklists/1.xml
  def destroy
    @swlist_blacklist = SwlistBlacklist.find(params[:id])
    @swlist_blacklist.destroy

    respond_to do |format|
      format.html { redirect_to(swlist_blacklists_url) }
      format.xml  { head :ok }
    end
  end
end
