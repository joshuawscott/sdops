class SubcontractsController < ApplicationController
  before_filter :authorized?, :except => [:show, :index]
  # GET /subcontracts
  # GET /subcontracts.xml
  def index
    if params[:subcontractor]
      @subcontracts = Subcontract.current.find(:all,:conditions => {:subcontractor_id => params[:subcontractor]})
    elsif params[:view_all] == "1"
      @subcontracts = Subcontract.find(:all)
      @viewing_all = true
    else
      @subcontracts = Subcontract.current
      @viewing_all = false
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subcontracts }
      format.js 
    end
  end

  # GET /subcontracts/1
  # GET /subcontracts/1.xml
  def show
    @subcontract = Subcontract.find(params[:id])
    @comments = @subcontract.comments.sort {|x,y| y.created_at <=> x.created_at}
    @line_items = @subcontract.line_items.sort_by {|x| x.position}
    @comment = Comment.new
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subcontract }
      format.js
    end
  end

  # GET /subcontracts/new
  # GET /subcontracts/new.xml
  def new
    @subcontract = Subcontract.new
    @subcontractors = Subcontractor.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subcontract }
    end
  end

  # GET /subcontracts/1/edit
  def edit
    @subcontract = Subcontract.find(params[:id])
    @subcontractors = Subcontractor.find(:all)
  end

  # POST /subcontracts
  # POST /subcontracts.xml
  def create
    @subcontract = Subcontract.new(params[:subcontract])

    respond_to do |format|
      if @subcontract.save
        flash[:notice] = 'Subcontract was successfully created.'
        format.html { redirect_to(@subcontract) }
        format.xml  { render :xml => @subcontract, :status => :created, :location => @subcontract }
      else
        @subcontractors = Subcontractor.find(:all)
        format.html { render :action => "new" }
        format.xml  { render :xml => @subcontract.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subcontracts/1
  # PUT /subcontracts/1.xml
  def update
    @subcontract = Subcontract.find(params[:id])

    respond_to do |format|
      if @subcontract.update_attributes(params[:subcontract])
        flash[:notice] = 'Subcontract was successfully updated.'
        format.html { redirect_to(@subcontract) }
        format.xml  { head :ok }
      else
        @subcontractors = Subcontractor.find(:all)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subcontract.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subcontracts/1
  # DELETE /subcontracts/1.xml
  def destroy
    @subcontract = Subcontract.find(params[:id])
    @subcontract.destroy

    respond_to do |format|
      format.html { redirect_to(subcontracts_url) }
      format.xml  { head :ok }
    end
  end

  def add_line_items
    line_items = params[:line_items]
    @subcontract = Subcontract.find(params[:id])
    successful_line_items = 0
    failed_line_items = 0
    line_items.each do |l|
      @line_item = LineItem.find(l[:id])
      logger.debug l.inspect
      if @line_item.update_attribute("subcontract_cost", l["subcontract_cost"])
        successful_line_items += 1
      else
        failed_line_items += 1
      end
      @subcontract.line_items << @line_item
    end
    flash[:notice] = "Successfully updated #{successful_line_items} line items"
    flash[:notice] << "<br>Failed to update #{failed_line_items} line items" if failed_line_items > 0
    redirect_to subcontract_path(@subcontract)
  end

  def remove_line_item
    @subcontract = Subcontract.find params[:id]
    @line_item = LineItem.find(params[:line_item_id])
    @line_item.remove_from @subcontract
    redirect_to subcontract_path(@subcontract)
  end

  def authorized?
    current_user && current_user.has_role?(:contract_admin)
  end
end
