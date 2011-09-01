# Custom fields for SugarAcct (fields that the Sugar administrators have added).
# This is occasionally updated, so the Schema may be out of date.  Not all
# fields are used; please refer to SugarCRM to determine which fields are used.
# ===Schema
#   id_c                string
#   channelmanager_c    string
#   channelpartner_c    string
#   account_type_c      string
#   partneragreement_c  string
#   cmanagernotes_c     text
#   client_category_c   string
#   channelacctprimarycbm_c string
#   channelacctsalestype_c  string
#   channelacctregion_c     string
#   channelacctbrands_c     text
#   channelacctindustries_c text
#   channelbrands_c         text
#   channelindustries_c     text
#   channelproductsservices_c text
#   channelhardware_c       text
#   rmmoperatingsystem_c    string
#   rmmservicelevel_c       text
#   rmmoperatingsystem2_c   text
class SugarAccountsCstm < SugarDb
  set_table_name "accounts_cstm"
  belongs_to :sugar_acct, :foreign_key => :id_c
end