class RolesController < ApplicationController
  before_filter :authorized?

  # GET /roles
  # GET /roles.xml
  def index
    @roles = Role.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id], :include => :users)
    @users = User.find(:all, :order => "first_name, last_name ASC")
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @role = Role.find(params[:id])

    respond_to do |format|
      if @role.update_attributes(params[:role])
        flash[:notice] = 'Role was successfully updated.'
        format.html { redirect_to(roles_path  ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end
  protected
  def authorized?
    (current_user.role == ADMIN || current_user.has_role('admin')) || not_authorized
  end


end
