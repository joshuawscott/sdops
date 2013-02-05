class FootprintsCategoriesController < ApplicationController
  # GET /footprints_categories
  # GET /footprints_categories.xml
  def index
    @footprints_categories = FootprintsCategory.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @footprints_categories }
    end
  end

  # GET /footprints_categories/1
  # GET /footprints_categories/1.xml
  def show
    @footprints_category = FootprintsCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @footprints_category }
    end
  end

  # GET /footprints_categories/new
  # GET /footprints_categories/new.xml
  def new
    @footprints_category = FootprintsCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @footprints_category }
    end
  end

  # GET /footprints_categories/1/edit
  def edit
    @footprints_category = FootprintsCategory.find(params[:id])
  end

  # POST /footprints_categories
  # POST /footprints_categories.xml
  def create
    @footprints_category = FootprintsCategory.new(params[:footprints_category])

    respond_to do |format|
      if @footprints_category.save
        flash[:notice] = 'FootprintsCategory was successfully created.'
        format.html { redirect_to(@footprints_category) }
        format.xml  { render :xml => @footprints_category, :status => :created, :location => @footprints_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @footprints_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /footprints_categories/1
  # PUT /footprints_categories/1.xml
  def update
    @footprints_category = FootprintsCategory.find(params[:id])

    respond_to do |format|
      if @footprints_category.update_attributes(params[:footprints_category])
        flash[:notice] = 'FootprintsCategory was successfully updated.'
        format.html { redirect_to(@footprints_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @footprints_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /footprints_categories/1
  # DELETE /footprints_categories/1.xml
  def destroy
    @footprints_category = FootprintsCategory.find(params[:id])
    @footprints_category.destroy

    respond_to do |format|
      format.html { redirect_to(footprints_categories_url) }
      format.xml  { head :ok }
    end
  end
end
