# Schema:
# TODO: fill in
class SugarContact < SugarDb
  set_table_name "contacts"
  named_scope :valid, :conditions => {:deleted => 0}
  has_many :sugar_accounts_contacts, :foreign_key => "contact_id"
  has_many :sugar_accts, :through => :sugar_accounts_contacts, :foreign_key => "contact_id"
  def self.find_with_email(*args)
    if args.length == 1
      if args.class == Array
        self.valid.find(:all,
          :select => 'contacts.*, email_addresses.email_address',
          :joins => 'LEFT JOIN email_addr_bean_rel ON contacts.id = email_addr_bean_rel.bean_id AND email_addr_bean_rel.bean_module = "Contacts" AND primary_address = 1 AND email_addr_bean_rel.deleted = 0 LEFT JOIN email_addresses ON email_addr_bean_rel.email_address_id = email_addresses.id',
          :conditions => {:id => args[0]} )
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
