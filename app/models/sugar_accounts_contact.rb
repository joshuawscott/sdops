class SugarAccountsContact < SugarDb
  set_table_name "accounts_contacts"
  belongs_to :sugar_contact, :foreign_key => "contact_id"
  belongs_to :sugar_acct, :foreign_key => "account_id"
end