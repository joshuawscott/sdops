class ProductDealsController < ApplicationController
  #TODO: Determine if login required
  # GET /product_deals
  # GET /product_deals.xml
  def index
    @product_deals = ProductDeal.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_deals }
    end
  end

  # GET /product_deals/1
  # GET /product_deals/1.xml
  def show
    @product_deal = ProductDeal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_deal }
    end
  end

  # GET /product_deals/new
  # GET /product_deals/new.xml
  def new
    @product_deal = ProductDeal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_deal }
    end
  end

  # GET /product_deals/1/edit
  def edit
    @product_deal = ProductDeal.find(params[:id])
  end

  # POST /product_deals
  # POST /product_deals.xml
  def create
    @product_deal = ProductDeal.new(params[:product_deal])

    respond_to do |format|
      if @product_deal.save
        flash[:notice] = 'ProductDeal was successfully created.'
        format.html { redirect_to(@product_deal) }
        format.xml  { render :xml => @product_deal, :status => :created, :location => @product_deal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product_deal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /product_deals/1
  # PUT /product_deals/1.xml
  def update
    @product_deal = ProductDeal.find(params[:id])

    respond_to do |format|
      if @product_deal.update_attributes(params[:product_deal])
        flash[:notice] = 'ProductDeal was successfully updated.'
        format.html { redirect_to(@product_deal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_deal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_deals/1
  # DELETE /product_deals/1.xml
  def destroy
    @product_deal = ProductDeal.find(params[:id])
    logger.info current_user.login + " destroyed product_deal " + @product_deal.id.to_s
    @product_deal.destroy

    respond_to do |format|
      format.html { redirect_to(product_deals_url) }
      format.xml  { head :ok }
    end
  end
end
