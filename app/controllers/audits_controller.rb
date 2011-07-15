#integer  "auditable_id"
#string   "auditable_type"
#integer  "user_id"
#string   "user_type"
#string   "username"
#string   "action"
#text     "changes"
#integer  "version",        :default => 0
#datetime "created_at"
# * <tt>auditable</tt>: the ActiveRecord model that was changed
# * <tt>user</tt>: the user that performed the change; a string or an ActiveRecord model
# * <tt>action</tt>: one of create, update, or delete
# * <tt>changes</tt>: a serialized hash of all the changes
# * <tt>created_at</tt>: Time that the change was performed
class AuditsController < ApplicationController
  before_filter :authorized?

  def index
    @models = Audit.audited_classes.map {|x| x.to_s}.sort
    #@users = Audit.find(:all, :include => :user).map {|a| a.user.nil? ? "system" : a.user.login}.uniq.sort
    @users = User.find(:all).map{|a| a.login}.sort
    @users << 'system'
  end

  def focus
    @model = params[:model]
    @audits = Audit.find(:all, :conditions => ['auditable_type = ?', @model], :order => 'id DESC', :limit => 5000)
  end

  def user
    @user = params[:user] == 'system' ?
      User.new(:first_name => '', :last_name => 'system') :
      User.find(:first, :conditions => {:login => params[:user]})
    @audits = Audit.find(:all, :conditions => {:user_id => @user.id}, :order => 'id DESC', :limit => 5000)
  end

  def show
    @audit = Audit.find(params[:id])
    @user = @audit.user_id.nil? ?
      User.new(:last_name => 'system', :login => 'system') :
      User.find(@audit.user_id)
  end

  def history
    @audit = Audit.find(params[:id])
    @audits = Audit.find(:all, :conditions => {:auditable_type => @audit.auditable_type, :auditable_id => @audit.auditable_id})
  end
  protected
  def authorized?
    current_user.has_role?(:auditor) || not_authorized
  end
end
