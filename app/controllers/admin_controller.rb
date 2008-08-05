class AdminController < ApplicationController
  before_filter :authorized?
  
  # GET /admin
  def index
  
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  
  protected  
  def authorized?
    #logged_in?
    #debugger
    if logged_in? && current_user.role == ADMIN
       true
    else
       not_authorized
    end
  end

end
