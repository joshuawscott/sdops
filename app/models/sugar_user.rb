# Schema:
#   id                  integer
#   user_name           string
#   user_hash           string
#   authenticate_id     string
#   sugar_login         boolean
#   first_name          string
#   last_name           string
#   reports_to_id       string
#   is_admin            boolean
#   receive_notifications   boolean
#   description         text
#   date_entered        datetime
#   date_modified       datetime
#   modified_user_id    string
#   created_by          string
#   title               string
#   department          string
#   phone_home          string
#   phone_mobile        string
#   phone_work          string
#   phone_other         string
#   phone_fax           string
#   email1              string DEPRECATED
#   email2              string DEPRECATED
#   status              string
#   address_street      string
#   address_city        string
#   address_state       string
#   address_country     string
#   address_postalcode  string
#   user_preferences    text
#   default_team        string
#   deleted             boolean
#   portal_only         boolean
#   employee_status     string
#   messenger_id        string
#   messenger_type      string
#   is_group            boolean
class SugarUser < SugarDb
  set_table_name "users"
  has_many :sugar_team_memberships, :foreign_key => 'user_id'
  has_many :sugar_teams, :through => :sugar_team_memberships

  # The email1 and email2 fields in this model are deprecated, so you should use getuserinfo rather than
  # a normal find in order to pull complete user information.  This gets an additional field 'email' that
  # is the primary email address for the user in SugarCRM
  #
  # usersids can be an id, or an array of ids.
  def self.getuserinfo(userids)
    SugarUser.find(userids, :select => 'users.*, email_addresses.email_address as email',
      :joins => 'LEFT JOIN (email_addr_bean_rel CROSS JOIN email_addresses) ON (users.id=email_addr_bean_rel.bean_id AND email_addr_bean_rel.bean_module="Users" AND email_addr_bean_rel.email_address_id=email_addresses.id)',
      :conditions => 'users.status = "Active" AND email_addr_bean_rel.primary_address = 1 AND email_addr_bean_rel.deleted = 0')
  end
  def name
    first_name.to_s + " " + last_name.to_s
  end
end
