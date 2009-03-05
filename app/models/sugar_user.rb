class SugarUser < SugarDb
  set_table_name "users"

  def self.getuserinfo(userids)
    SugarUser.find(userids, :select => 'users.*, email_addresses.email_address as email',
      :joins => 'LEFT JOIN (email_addr_bean_rel CROSS JOIN email_addresses) ON (users.id=email_addr_bean_rel.bean_id AND email_addr_bean_rel.bean_module="Users" AND email_addr_bean_rel.email_address_id=email_addresses.id)',
      :conditions => 'users.status = "Active" AND email_addr_bean_rel.primary_address = 1 AND email_addr_bean_rel.deleted = 0')
  end
  
end
