class AdminController < ApplicationController
  before_filter :authorized?
  
  # GET /admin
  def index
  
    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # GET /admin/lineitems
  def lineitems
    #TODO: fix this to a normal find
    @contracts = Contract.find_by_sql("select c.id, c.account_name, c.description, c.end_date, count(l.id) as line_items FROM `contracts` c left join line_items as l on c.id = l.contract_id where c.expired <> true group by c.id having count(l.id) = 0 ORDER BY c.end_date DESC, c.account_name, c.description")

    respond_to do |format|
      format.html # lineitems.html.haml
    end
  end
  
  # GET /admin/account_id
  def account_id
    @contracts = Contract.find(:all, :conditions => 'CHAR_LENGTH(account_id) < 2', :order => 'account_name, start_date')

    respond_to do |format|
      format.html # account_id.html.haml
    end
  end
  
  # GET /admin/cashflow
  def cashflow
    @contracts = Contract.find(:all, :conditions => 'expired <> true', :include => :predecessors, :order => 'end_date, account_name')

    respond_to do |format|
      format.html # cashflow.html.haml
    end
  end

  protected  
  def authorized?
    if logged_in? && current_user.role == ADMIN
       true
    else
       not_authorized
    end
  end

end
