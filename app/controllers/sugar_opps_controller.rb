class SugarOppsController < ApplicationController
  # GET /sugar_opps
  # GET /sugar_opps.xml
  def index
    @sugar_opps = SugarOpp.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sugar_opps }
    end
  end

  # GET /sugar_opps/1
  # GET /sugar_opps/1.xml
  def show
    @sugar_opp = SugarOpp.find(params[:id])
    #@opportunity = Opportunity.find(@sugar_opp)

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @sugar_opp }
    end
  end

  ## GET /sugar_opps/new
  ## GET /sugar_opps/new.xml
  #def new
  #  @sugar_opp = SugarOpp.new
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.xml  { render :xml => @sugar_opp }
  #  end
  #end
  #
  ## GET /sugar_opps/1/edit
  #def edit
  #  @sugar_opp = SugarOpp.find(params[:id])
  #end

  ## POST /sugar_opps
  ## POST /sugar_opps.xml
  #def create
  #  @sugar_opp = SugarOpp.new(params[:sugar_opp])
  #
  #  respond_to do |format|
  #    if @sugar_opp.save
  #      flash[:notice] = 'SugarOpp was successfully created.'
  #      format.html { redirect_to(@sugar_opp) }
  #      format.xml  { render :xml => @sugar_opp, :status => :created, :location => @sugar_opp }
  #    else
  #      format.html { render :action => "new" }
  #      format.xml  { render :xml => @sugar_opp.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  ## PUT /sugar_opps/1
  ## PUT /sugar_opps/1.xml
  #def update
  #  @sugar_opp = SugarOpp.find(params[:id])
  #
  #  respond_to do |format|
  #    if @sugar_opp.update_attributes(params[:sugar_opp])
  #      flash[:notice] = 'SugarOpp was successfully updated.'
  #      format.html { redirect_to(@sugar_opp) }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @sugar_opp.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end
  #
  ## DELETE /sugar_opps/1
  ## DELETE /sugar_opps/1.xml
  #def destroy
  #  @sugar_opp = SugarOpp.find(params[:id])
  #  logger.info current_user.login + " destroyed sugar_opp " + @sugar_opp.id.to_s
  #  @sugar_opp.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to(sugar_opps_url) }
  #    format.xml  { head :ok }
  #  end
  #end
end
