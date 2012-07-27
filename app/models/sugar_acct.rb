# A SugarAcct is an account in SugarCRM.  This is used to populate the account
# information for a SupportDeal and in other places.
# ===Schema
#   id                string
#   date_entered      datetime
#   date_modified     datetime
#   modified_user_id  string
#   assigned_user_id  string
#   created_by        string
#   name              string
#   parent_id         string
#   account_type      string
#   industry          string
#   annual_revenue    string
#   phone_fax         string
#   billing_address_street      string
#   billing_address_city        string
#   billing_address_state       string
#   billing_address_postalcode  string
#   billing_address_country     string
#   description       text
#   rating            string
#   phone_office      string
#   phone_alternate   string
#   email1            string
#   email2            string
#   website           string
#   ownership         string
#   employees         string
#   sic_code          string
#   ticker_symbol     string
#   shipping_address_street       string
#   shipping_address_city         string
#   shipping_address_state        string
#   shipping_address_postalcode   string
#   shipping_address_country      string
#   deleted       boolean
#   campaign_id   string
#   team_id       string
class SugarAcct < SugarDb
  set_table_name "accounts"

  has_many :sugar_acct_opps, :foreign_key => "account_id"
  has_many :sugar_opps, :through => :sugar_acct_opps, :foreign_key => "account_id"
  has_many :contracts, :foreign_key => "account_id"
  has_one :sugar_accounts_cstm, :foreign_key => "id_c"
  has_many :sugar_accounts_contacts, :foreign_key => "account_id"
  has_many :sugar_contacts, :through => :sugar_accounts_contacts, :foreign_key => "account_id"

  # convenience method to pull client_category_c from SugarAccountsCstm.
  def client_category
    begin
      @client_category = self.sugar_accounts_cstm.client_category_c
    rescue
      @client_category = nil
    end
  end

  # Pull all linked contacts while including the email address field.
  def sugar_contacts_with_email
    sugar_contact_ids = sugar_contacts.map {|sc| sc.id}
    SugarContact.find_with_email(sugar_contact_ids)
  end

  def revenue_as_of(date)
    @revenue_as_of = BigDecimal.new("0.0")
    self.contracts.each do |contract|
      @revenue_as_of += contract.total_revenue if (contract.start_date <= date && contract.end_date >= date)
    end
    @revenue_as_of
  end
  def revenue_now
    @revenue_now = BigDecimal.new("0.0")
    self.contracts.each do |contract|
      @revenue_now += contract.total_revenue if contract.expired == false
    end
    @revenue_now
  end

  def partner?
    return false if self.sugar_accounts_cstm.nil?
    self.sugar_accounts_cstm.channeltype_c == 'Partner'
  end

  def end_users
    #Short circuit unless it's a partner.
    return Array.new unless partner?
    SugarAcct.find(:all, :joins => :sugar_accounts_cstm, :conditions => ['accounts_cstm.channelpartner_c = ? AND accounts.id <> ?', self.id, self.id])
  end
end
