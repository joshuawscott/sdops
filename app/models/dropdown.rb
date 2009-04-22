# Schema:
#   id          integer
#   dd_name     string
#   filter      string
#   label       string
#   created_at  datetime
#   updated_at  datetime
#   sort_order  integer
# Various dropdowns stored in the Database.
class Dropdown < ActiveRecord::Base
   def self.office_list
     Dropdown.find(:all, :conditions => "dd_name = 'office'",
                          :select => "label",
                          :order => "sort_order")
   end

   def self.role_list
     Dropdown.find(:all, :conditions => "dd_name = 'roles'",
                                 :select => "id, label",
                                 :order => "sort_order")
   end

   def self.role_lables
     temp = Dropdown.find(:all, :conditions => "dd_name = 'roles'",
                                 :select => "id, label",
                                 :order => "sort_order")
     roles = {}
     temp.map {|x| roles[x.id] = x.label}
     roles
   end

   def self.payment_terms_list
		 Dropdown.find(:all, :conditions => "dd_name = 'payment_terms'",
                          :select => "label",
                          :order => "sort_order")
   end

   def self.platform_list
     Dropdown.find(:all, :conditions => "dd_name = 'platform'",
                          :select => "label",
                          :order => "sort_order")
   end

   def self.support_type_list_hw
     Dropdown.find(:all, :conditions => "dd_name = 'support_type' AND filter = 'hardware'",
                          :select => "label",
                          :order => "sort_order")
   end

   def self.support_type_list_sw
     Dropdown.find(:all, :conditions => "dd_name = 'support_type' AND filter = 'software'",
                          :select => "label",
                          :order => "sort_order")
   end


	 def self.support_provider_list
		 Dropdown.find(:all, :conditions => "dd_name = 'support_providers'",
                          :select => "label",
                          :order => "sort_order")
	 end

end
