# A SugarContact is a specific person that works for a SugarAcct.
# ===Schema
#   id        string
#   date_entered  time
#   date_modified time
#   modified_user_id  string
#   created_by    string
#   description   text
#   deleted       boolean
#   assigned_user_id  string
#   saluatation   string
#   first_name    string
#   last_name     string
#   title         string
#   department    string
#   do_not_call   boolean
#   phone_home    string
#   phone_mobile  string
#   phone_work    string
#   phone_other   string
#   phone_fax     string
#   primary_address_street      string
#   primary_address_city        string
#   primary_address_state       string
#   primary_address_postalcode  string
#   primary_address_country     string
#   alt_address_street      string
#   alt_address_city        string
#   alt_address_state       string
#   alt_address_postalcode  string
#   alt_address_country     string
#   assistant       string
#   assistant_phone string
#   lead_source     string
#   reports_to_id   string
#   birthdate       date
#   portal_name     string
#   portal_active   string
#   portal_app      string
#   campaign_id     string
#   team_id         string
#
#
class SugarContact < SugarDb
  set_table_name "contacts"
  named_scope :valid, :conditions => {:deleted => 0}
  has_many :sugar_accounts_contacts, :foreign_key => "contact_id"
  has_many :sugar_accts, :through => :sugar_accounts_contacts, :foreign_key => "contact_id"

  # Works somewhat like find.  There are 3 different argument styles that
  # produce different results:
  # 1.  Pass a single Array of id strings *or* SugarContact objects.
  # 2.  Pass a single id string *or* SugarContact object.
  # 3.  Call it like find.  Example:
  #       SugarContact.find_with_email(_scope_, _args_)
  #     Where _scope_ is a valid scope for find (i.e. :first, :last, :all) and
  #     _args_ is a hash of options (only :conditions and :limit are accepted)
  #     Note that :select, :joins, :include, :order, and :group are not supported.
  def self.find_with_email(*args)
    if args.length == 1
      if args.class == Array
        self.valid.find(:all,
                        :select => 'contacts.*, email_addresses.email_address',
                        :joins => 'LEFT JOIN email_addr_bean_rel ON contacts.id = email_addr_bean_rel.bean_id AND email_addr_bean_rel.bean_module = "Contacts" AND primary_address = 1 AND email_addr_bean_rel.deleted = 0 LEFT JOIN email_addresses ON email_addr_bean_rel.email_address_id = email_addresses.id',
                        :conditions => {:id => args[0]})
      else
        self.valid.find(:first,
                        :select => 'contacts.*, email_addresses.email_address',
                        :joins => 'LEFT JOIN email_addr_bean_rel ON contacts.id = email_addr_bean_rel.bean_id AND email_addr_bean_rel.bean_module = "Contacts" AND primary_address = 1 AND email_addr_bean_rel.deleted = 0 LEFT JOIN email_addresses ON email_addr_bean_rel.email_address_id = email_addresses.id',
                        :conditions => {:id => args[0]})

      end
    else
      scope = args[0]
      options = args[1]
      self.valid.find(scope,
                      :select => 'contacts.*, email_addresses.email_address',
                      :conditions => options[:conditions],
                      :joins => 'LEFT JOIN email_addr_bean_rel ON contacts.id = email_addr_bean_rel.bean_id AND email_addr_bean_rel.bean_module = "Contacts" AND primary_address = 1 AND email_addr_bean_rel.deleted = 0 LEFT JOIN email_addresses ON email_addr_bean_rel.email_address_id = email_addresses.id',
                      :limit => options[:limit])
    end
  end
end
