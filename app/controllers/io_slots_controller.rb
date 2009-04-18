class IoSlotsController < ApplicationController
  # GET /io_slots
  # GET /io_slots.xml
  before_filter :get_server
  def index
    @io_slots = IoSlot.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @io_slots }
    end
  end

  # GET /io_slots/1
  # GET /io_slots/1.xml
  def show
    @io_slot = IoSlot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @io_slot }
    end
  end

  # GET /io_slots/new
  # GET /io_slots/new.xml
  def new
    @io_slot = @server.io_slots.new

    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @io_slot }
    end
  end

  # GET /io_slots/1/edit
  def edit
    @io_slot = IoSlot.find(params[:id])
  end

  # POST /io_slots
  # POST /io_slots.xml
  def create
    @io_slot = @server.io_slots.new(params[:io_slot])
    
    respond_to do |format|
      if @io_slot.save
        flash[:notice] = 'IoSlot was successfully created.'
        @io_slot = nil
        format.html { render :action => "new" }
        format.xml  { render :xml => @server, :status => :created, :location => @server }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @io_slot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /io_slots/1
  # PUT /io_slots/1.xml
  def update
    @io_slot = IoSlot.find(params[:id])

    respond_to do |format|
      if @io_slot.update_attributes(params[:io_slot])
        flash[:notice] = 'IoSlot was successfully updated.'
        format.html { redirect_to(@server) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @io_slot.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /io_slots/1
  # DELETE /io_slots/1.xml
  def destroy
    @io_slot = IoSlot.find(params[:id])
    @io_slot.destroy

    respond_to do |format|
      format.html { redirect_to(@server) }
      format.xml  { head :ok }
    end
  end

  protected
  def get_server
    @server = Server.find params[:server_id]
  end
end
