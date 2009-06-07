class IoSlotsController < ApplicationController
  before_filter :authorized?, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :get_server
  # GET /servers/:server_id/io_slots/new
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

  # POST /servers/:server_id/io_slots
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

  # PUT /servers/:server_id/io_slots/:id
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

  # DELETE /servers/:server_id/io_slots/:id
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

  def authorized?
    current_user.role == ADMIN || not_authorized
  end

end
