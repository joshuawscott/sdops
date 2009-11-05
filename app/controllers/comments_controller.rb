class CommentsController < ApplicationController
  before_filter :authorized?

  before_filter :find_commenter, :only => [:new, :create, :update,  :destroy] 

  ## GET /comments
  ## GET /comments.xml
  #def index
  #  @comments = Comment.find(:all)
  #  
  #  respond_to do |format|
  #    format.html # index.html.erb
  #  end
  #end
  #
  ## GET /comments/1
  ## GET /comments/1.xml
  #def show
  #  @comment = Comment.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #  end
  #end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create

    @comment = @commenter.comments.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to :controller => @commenter.class.to_s.pluralize.downcase, :action => :show, :id => @commenter.id }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comments = Comment.find(params[:id])

    respond_to do |format|
      if @comments.update_attributes(params[:comment])
        #flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to :controller => @commenter.class.to_s.pluralize.downcase, :action => :show, :id => @commenter.id }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comments.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comments = Comment.find(params[:id])
    logger.info current_user.login + " destroyed comment " + @comments.id.to_s
    @comments.destroy

    respond_to do |format|
      format.html { redirect_to :controller => @commenter.class.to_s.pluralize.downcase, :action => :show, :id => @commenter.id }
      format.xml  { head :ok }
    end
  end
  
  
  protected  
  def authorized?
    current_user.has_role?(:commenter) || not_authorized
  end
  
  private

  def find_commenter
    if params[:comment]
      klass = params[:comment][:commentable_type].singularize.camelize.constantize
      @commenter = klass.find(params[:comment][:commentable_id])     
    else
      klass = params[:commentable_type].singularize.camelize.constantize
      @commenter = klass.find(params[:commentable_id])
    end
    
  end

end
