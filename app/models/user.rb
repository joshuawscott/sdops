#require 'digest/sha1'
require 'digest/md5'
class User < ActiveRecord::Base
  
  #has_many :sugar_team_memberships, :foreign_key => :user_id

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
  attr_accessible :login, :email, :password, :password_confirmation, :first_name, :last_name, :office, :role

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
    if self.role >= ADMIN
      SugarTeamMembership.find(:all, :select => "team_id", :conditions => "deleted = 0 AND team_id NOT LIKE '%private%'", :group => "team_id").map {|x| x.team_id}
    else
      SugarTeamMembership.find(:all, :select => "team_id", :conditions => "user_id = '#{self.sugar_id}' AND deleted = 0  AND team_id NOT LIKE '%private%'", :group => "team_id").map {|x| x.team_id}
    end
  end
  
  def self.update_from_sugar()
    sugar_users = SugarUser.find(:all, :conditions => "status = 'Active'")
    failures = []
    sugar_users.map do |x|
      local_user = User.find(:first, :conditions => ["login = ?", x.user_name])
      if local_user
        logger.info x.user_name + " exists, updating..."
				local_user.first_name = x.first_name
				local_user.last_name = x.last_name
				# TODO: sugar functionality does not update the email1 field any longer, find another way to extract from sugar
        local_user.email = x.email1 == nil ? local_user.email : x.email1
        local_user.crypted_password = x.user_hash
        local_user.office = x.default_team
        local_user.sugar_id = x.id
        if local_user.save
          #all ok
        else
          failures << x.user_name
        end
      else
        logger.info x.user_name + " does not exist, creating..."
				local_user = User.new
        local_user.login = x.user_name
        local_user.first_name = x.first_name
        local_user.last_name = x.last_name
        local_user.email = x.email1 == nil ? x.user_name + '@sourcedirect.com' : x.email1
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
