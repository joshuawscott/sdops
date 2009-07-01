# Schema:
#   id                integer
#   login             string
#   first_name        string
#   last_name         string
#   office            string
#   email             string
#   role              integer
#   sugar_id          string
#   crypted_password  string
#   salt              string
#   created_at        datetime
#   updated_at        datetime
#   remember_token    string
#   remember_token_expires_at  datetime
require 'digest/md5'
class User < ActiveRecord::Base

  # Uncomment the next line to get access to see the audited changes to the User model:
  #has_many :changes, :class_name => 'Audit', :as => :user
  #has_many :sugar_team_memberships, :foreign_key => :user_id
  has_many :permissions
  has_many :roles, :through => :permissions

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email, :first_name, :last_name
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :first_name, :last_name, :office, :role, :role_ids
  acts_as_audited :except => [:password]

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password)
    #Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    Digest::MD5.hexdigest("#{password}")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def full_name
		[first_name, last_name].join(' ')
	end
  
  def self.user_list
     User.find(:all, :order => "last_name")
  end

  def sugar_team_ids
    if has_role?(:admin, :manager)
      SugarTeamMembership.find(:all, :select => "team_id", :conditions => "deleted = 0", :group => "team_id").map {|x| x.team_id}
    else
      SugarTeamMembership.find(:all, :select => "team_id", :conditions => "user_id = '#{self.sugar_id}'", :group => "team_id").map {|x| x.team_id}
    end
  end

  # Updates local users' information from SugarCRM
  def self.update_from_sugar()
    sugar_users = SugarUser.getuserinfo(:all)
    failures = []
    sugar_users.map do |x|
      local_user = User.find(:first, :conditions => ["login = ?", x.user_name])
      if local_user
        logger.debug x.user_name + " exists, updating..."
				local_user.first_name = x.first_name
				local_user.last_name = x.last_name
        local_user.email = x.email
        local_user.crypted_password = x.user_hash
        local_user.office = x.default_team
        local_user.sugar_id = x.id
        if local_user.save
          #all ok
        else
          failures << x.user_name
        end
      else
        logger.debug x.user_name + " does not exist, creating..."
				local_user = User.new
        local_user.login = x.user_name
        local_user.first_name = x.first_name
        local_user.last_name = x.last_name
        local_user.email = x.email
        local_user.crypted_password = x.user_hash
        local_user.office = x.default_team
        local_user.sugar_id = x.id
        if local_user.save
          #all ok
        else
          failures << x.user_name
        end
      end
    end
    failures
  end

  # Takes any number of Role names as symbols or strings, returning true if the user has any of the supplied role(s)
  def has_role?(*args)
    # The first part of this compiles an array of common elements between the passed args and
    # the roles of this User instance.  If the length is > 0, then we have a match.
    (roles.map {|r| r.name} &(args.map{|a| a.to_s})).length > 0
  end

  def role_names
    roles.map {|r| r.name}
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      #self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end


end
