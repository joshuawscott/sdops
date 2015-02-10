# ===Schema:
#   id          integer
#   dd_name     string
#   filter      string
#   label       string
#   created_at  datetime
#   updated_at  datetime
#   sort_order  integer
# Various dropdowns stored in the Database, to allow user interaction and change.
class Dropdown < ActiveRecord::Base
  def self.office_list
    Dropdown.find(:all, :conditions => "dd_name = 'office'",
                  :select => "label",
                  :order => "sort_order")
  end

  # ==DEPRECATED
  # List of roles
  def self.role_list
    Dropdown.find(:all, :conditions => "dd_name = 'roles'",
                  :select => "id, label",
                  :order => "sort_order")
  end

  # ==DEPRECATED
  # List of lables for roles
  def self.role_lables
    temp = Dropdown.find(:all, :conditions => "dd_name = 'roles'",
                         :select => "id, label",
                         :order => "sort_order")
    roles = {}
    temp.map { |x| roles[x.id] = x.label }
    roles
  end

  # Possible payment terms
  def self.payment_terms_list
    Dropdown.find(:all, :conditions => "dd_name = 'payment_terms'",
                  :select => "label",
                  :order => "sort_order")
  end

  # List of platforms (semi-deprecated)
  def self.platform_list
    Dropdown.find(:all, :conditions => "dd_name = 'platform'",
                  :select => "label",
                  :order => "sort_order")
  end

  # Possible Hardware support levels
  def self.support_type_list_hw
    Dropdown.find(:all, :conditions => "dd_name = 'support_type' AND filter = 'hardware'",
                  :select => "label",
                  :order => "sort_order")
  end

  # Possible Software support levels
  def self.support_type_list_sw
    Dropdown.find(:all, :conditions => "dd_name = 'support_type' AND filter = 'software'",
                  :select => "label",
                  :order => "sort_order")
  end

  # ==DEPRECATED
  # Support providers - should be pulled from the subcontractors table now.
  def self.support_provider_list
    Dropdown.find(:all, :conditions => "dd_name = 'support_providers'",
                  :select => "label",
                  :order => "sort_order")
  end

end
