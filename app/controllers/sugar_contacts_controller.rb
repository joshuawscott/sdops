class SugarContactsController < ApplicationController

  def index
    if params[:account_id]
      @sugar_contacts = SugarAcct.find(params[:account_id]).sugar_contacts_with_email
    else
      @sugar_contacts = SugarContact.find_with_email :all
    end
    respond_to do |format|
      format.json { render :json => @sugar_contacts }
    end
  end

  def show
    @sugar_contact = SugarContact.find_with_email params[:id]
    respond_to do |format|
      format.json { render :json => @sugar_contact }
    end
  end

end