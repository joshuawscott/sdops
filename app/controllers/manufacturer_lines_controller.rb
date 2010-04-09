class ManufacturerLinesController < ApplicationController
  # GET /manufacturer_lines
  # GET /manufacturer_lines.xml
  before_filter :get_mfgs
  def index
    @manufacturer_lines = ManufacturerLine.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @manufacturer_lines }
    end
  end

  # GET /manufacturer_lines/1
  # GET /manufacturer_lines/1.xml
  def show
    @manufacturer_line = ManufacturerLine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @manufacturer_line }
    end
  end

  # GET /manufacturer_lines/new
  # GET /manufacturer_lines/new.xml
  def new
    @manufacturer_line = ManufacturerLine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @manufacturer_line }
    end
  end

  # GET /manufacturer_lines/1/edit
  def edit
    @manufacturer_line = ManufacturerLine.find(params[:id])
  end

  # POST /manufacturer_lines
  # POST /manufacturer_lines.xml
  def create
    @manufacturer_line = ManufacturerLine.new(params[:manufacturer_line])

    respond_to do |format|
      if @manufacturer_line.save
        flash[:notice] = 'ManufacturerLine was successfully created.'
        format.html { redirect_to(@manufacturer_line) }
        format.xml  { render :xml => @manufacturer_line, :status => :created, :location => @manufacturer_line }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @manufacturer_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /manufacturer_lines/1
  # PUT /manufacturer_lines/1.xml
  def update
    @manufacturer_line = ManufacturerLine.find(params[:id])

    respond_to do |format|
      if @manufacturer_line.update_attributes(params[:manufacturer_line])
        flash[:notice] = 'ManufacturerLine was successfully updated.'
        format.html { redirect_to(@manufacturer_line) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @manufacturer_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /manufacturer_lines/1
  # DELETE /manufacturer_lines/1.xml
  def destroy
    @manufacturer_line = ManufacturerLine.find(params[:id])
    @manufacturer_line.destroy

    respond_to do |format|
      format.html { redirect_to(manufacturer_lines_url) }
      format.xml  { head :ok }
    end
  end

  def get_mfgs
    @manufacturers = Manufacturer.find(:all)
  end
end
