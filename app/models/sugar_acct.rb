class SugarAcct < SugarDb
  set_table_name "accounts"
  
  has_many :sugar_acct_opps, :foreign_key => "account_id"
  has_many :sugar_opps, :through => :sugar_acct_opps, :foreign_key => "account_id"
  has_many :contracts
  
end
