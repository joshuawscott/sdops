class UsersController < ApplicationController
  before_filter :authorized?, :only => [:new, :create, :edit, :update, :destroy, :refresh]

  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all, :order => "last_name, first_name")
    @roles_labels = Dropdown.role_lables
  
    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @users }
    end
  end
  
  #Refresh users from SugarCRM
  def refresh
    failures = User.update_from_sugar
    unless failures.empty?
			logger.error "**************************************"
			logger.error "*** Failed to update users from Sugar:"
			logger.error failures.to_s
			logger.error "**************************************"
      flash[:error] = 'Users were not updated - ' + failures.to_s
      redirect_to(users_path)
    else
			logger.info current_user.login + " Successfully updated users from Sugar"
      flash[:notice] = 'Users updated successfully'
      redirect_to(users_path)
    end
  end
  
  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
  
    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @user }
    end
  end
  
  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @team = SugarTeam.dropdown_list(current_user.sugar_team_ids)
    @roles = Dropdown.role_list
    
    respond_to do |format|
      format.html # new.html.erb
      #format.xml  { render :xml => @user }
    end
  end
  
  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @team = SugarTeam.dropdown_list(current_user.sugar_team_ids)
    @roles = Role.find(:all)
  end
  
  # POST /users
  # POST /users.xml
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        self.current_user = @user
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_back_or_default('/') }
        #format.html { redirect_to(users_path) }
        #format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        #format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User ' + @user.login + ' was successfully updated.'
        format.html { redirect_to(users_path) }
        #format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        #format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    logger.info current_user.login + " destroyed user " + @user.id.to_s
    @user.destroy
  
    respond_to do |format|
      format.html { redirect_to(users_url) }
      #format.xml  { head :ok }
    end
  end
  
  protected  
  def authorized?
    current_user.has_role?(:admin) || not_authorized
  end


end
