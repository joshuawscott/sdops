class OpportunitiesController < ApplicationController
  # GET /opportunities
  # GET /opportunities.xml
  def index
    #debugger
    @opportunities = SugarOpp.find(:all, :conditions => "sales_stage = 'Qualification' AND deleted <> 1")
    #@opportunities = Opportunity.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @opportunities }
    end
  end

  # GET /opportunities/1
  # GET /opportunities/1.xml
  def show
    @opportunity = SugarOpp.find(params[:id], :include => :opportunity)

    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @opportunity }
    end
  end

  # GET /opportunities/new
  # GET /opportunities/new.xml
  def new
    @opportunity = Opportunity.new

    respond_to do |format|
      format.html # new.html.erb
      #format.xml  { render :xml => @opportunity }
    end
  end

  # GET /opportunities/1/edit
  def edit
    @opportunity = Opportunity.find(params[:id])
  end

  # POST /opportunities
  # POST /opportunities.xml
  def create
    
    @opportunity = Opportunity.new(params[:opportunity])

    respond_to do |format|
      if @opportunity.save
        flash[:notice] = 'Opportunity was successfully created.'
        format.html { redirect_to(@opportunity) }
        #format.xml  { render :xml => @opportunity, :status => :created, :location => @opportunity }
      else
        format.html { render :action => "new" }
        #format.xml  { render :xml => @opportunity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /opportunities/1
  # PUT /opportunities/1.xml
  def update
    @opportunity = Opportunity.find(params[:id])

    respond_to do |format|
      if @opportunity.update_attributes(params[:opportunity])
        flash[:notice] = 'Opportunity was successfully updated.'
        format.html { redirect_to(@opportunity) }
        #format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        #format.xml  { render :xml => @opportunity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /opportunities/1
  # DELETE /opportunities/1.xml
  def destroy
    @opportunity = Opportunity.find(params[:id])
    @opportunity.destroy

    respond_to do |format|
      format.html { redirect_to(opportunities_url) }
      #format.xml  { head :ok }
    end
  end
  
  protected
  def authorized?
    logged_in?
    if logged_in? && current_user.role >= BASIC
       true
    else
       false
    end
  end

  
  
  

# models/search.rb
def products
  @products ||= find_products
end

def find_products
  Product.find(:all, :conditions => conditions)
end

def keyword_conditions
  ["products.name LIKE ?", "%#{keywords}%", "%#{keywords}%"] unless keywords.blank?
end

def minimum_price_conditions
  ["products.price >= ?", minimum_price] unless minimum_price.blank?
end

def maximum_price_conditions
  ["products.price <= ?", maximum_price] unless maximum_price.blank?
end

def category_conditions
  ["products.category_id = ?", category_id] unless category_id.blank?
end

def conditions
  [conditions_clauses.join(' AND '), *conditions_options]
end

def conditions_clauses
  conditions_parts.map { |condition| condition.first }
end

def conditions_options
  conditions_parts.map { |condition| condition[1..-1] }.flatten
end

def conditions_parts
  methods.grep(/_conditions$/).map { |m| send(m) }.compact
end


end
