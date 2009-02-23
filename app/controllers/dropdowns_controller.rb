class DropdownsController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :authorized?, :only => [:new, :create, :edit, :update, :destroy]

  # GET /dropdowns
  # GET /dropdowns.xml
  def index
    @dropdowns = Dropdown.find(:all, :order => "dd_name, filter, sort_order")
    #@dropdowns = Dropdown.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /dropdowns/1
  # GET /dropdowns/1.xml
  def show
    @dropdown = Dropdown.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /dropdowns/new
  # GET /dropdowns/new.xml
  def new
    @dropdown = Dropdown.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /dropdowns/1/edit
  def edit
    @dropdown = Dropdown.find(params[:id])
  end

  # POST /dropdowns
  # POST /dropdowns.xml
  def create
    @dropdown = Dropdown.new(params[:dropdown])

    respond_to do |format|
      if @dropdown.save
        flash[:notice] = 'Dropdown was successfully created.'
        format.html { redirect_to(dropdowns_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /dropdowns/1
  # PUT /dropdowns/1.xml
  def update
    @dropdowns = Dropdown.find(params[:id])

    respond_to do |format|
      if @dropdowns.update_attributes(params[:dropdown])
        flash[:notice] = 'Dropdown was successfully updated.'
        format.html { redirect_to(@dropdowns) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dropdowns.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dropdowns/1
  # DELETE /dropdowns/1.xml
  def destroy
    @dropdowns = Dropdown.find(params[:id])
    @dropdowns.destroy

    respond_to do |format|
      format.html { redirect_to(dropdowns_url) }
      format.xml  { head :ok }
    end
  end
  
  
  protected  
  def authorized?
    current_user.role == ADMIN || not_authorized
  end


end
