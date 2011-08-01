class SugarAcctsController < ApplicationController

  def index
    @sugar_accts = SugarAcct.find :all
    respond_to do |format|
      format.json { render :json => @sugar_accts }
      format.xml  { render :xml => @sugar_accts }
    end
  end
  def show
    @sugar_acct = SugarAcct.find params[:id]
    respond_to do |format|
      format.json { render :json => @sugar_acct }
    end
  end

end