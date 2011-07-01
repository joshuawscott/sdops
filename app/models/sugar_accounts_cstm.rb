class SugarAccountsCstm < SugarDb
  set_table_name "accounts_cstm"
  belongs_to :sugar_acct, :foreign_key => :id_c
end