class ManagedDealsController < ApplicationController

  before_filter :set_dropdowns, :only => [:new, :edit, :create, :update]
  def index
    @managed_deals = ManagedDeal.find(:all)
  end
  def new
    @managed_deal = ManagedDeal.new
    @end_users = []
  end

  def create
    @managed_deal = ManagedDeal.new(params[:managed_deal])

    respond_to do |format|
      if @managed_deal.save
        flash[:notice] = 'Managed Services Deal was successfully created.'
        format.html { redirect_to(@managed_deal) }
        format.xml  { render :xml => @managed_deal, :status => :created, :managed_deal => @managed_deal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @managed_deal.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @managed_deal = ManagedDeal.find(params[:id])
    @comments = @managed_deal.comments.sort {|x,y| y.created_at <=> x.created_at}
    @comment = Comment.new
  end

  def edit
    @managed_deal = ManagedDeal.find(params[:id])
    @end_users = @managed_deal.sugar_acct.end_users
  end

  def update
    @managed_deal = ManagedDeal.find(params[:id])

    respond_to do |format|
      if @managed_deal.update_attributes(params[:managed_deal])
        flash[:notice] = 'Managed Services Deal was successfully updated.'
        format.html { redirect_to(@managed_deal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @managed_deal.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @managed_deal = ManagedDeal.find(params[:id])
    logger.info current_user.login + " destroyed managed_deal " + @managed_deal.id.to_s
    @managed_deal.destroy

    respond_to do |format|
      format.html { redirect_to(managed_deals_path) }
      format.xml  { head :ok }
    end
  end

  private
  def set_dropdowns
    @sugar_accts = SugarAcct.find(:all, :select => "id, name", :conditions => "deleted = 0", :order => "name")
    @sales_offices =  SugarTeam.dropdown_list(current_user.sugar_team_ids)
    @pay_terms = Dropdown.payment_terms_list
    @sales_reps = User.user_list
  end


end
