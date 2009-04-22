# Schema:
#   id                string
#   name              string
#   list_order        integer
#   date_entered      datetime
#   date_modified     datetime
#   modified_user_id  string
#   created_by        string
#   deleted           boolean
# Current Types:
#   id                                    name
#   128bcb0e-4826-a011-6a8b-44d20ffd5964  Support - Annual
#   40f58b14-f5b1-02f9-7ccf-44d20f31ef7d  Support - Monthly
#   12449434-fa40-3dc0-a4ab-44d20f51a8ef  Support - Quarterly
#   5594ac8c-f30b-3891-0513-44d2107c90d8  Support - Annual - 2 years
#   9fdce785-d617-1033-b56e-44d210f62e39  Support - Annual - 3 years
#   93a7db0b-6fe8-28ce-f84f-44d210138539  Support - Annual - 4 years
#   a78fbe66-dcc8-cb53-35dc-44d210da29f5  Support - Annual - 5 years
#   37219a31-488c-0223-5227-44d20fd310ee  Support - Bundled - 1 year
#   1414beb5-050e-4d0d-bcca-44d20f5d1360  Support - Bundled - 2 year
#   b82ecb7e-1c3b-1944-c9cd-44d20f0fd5ee  Support - Bundled - 3 year
#   acdcaf04-c0f7-b06b-e932-44d20f31de2a  Support - Bundled - 4 year
#   b82473d4-5ad0-8595-8eb5-44d20f274345  Support - Bundled - 5 year
#   340926ed-5f40-3559-0e93-44d211808bb0  SysAdmin - Short Term
#   c67487aa-dc68-b66b-eaed-44d211bba4ab  SysAdmin - Long Term
#   7d896849-08fa-d3c9-cc6f-44d20f7e8d34  Disaster Recovery - QuickShip
#   c9960e94-6efa-b703-bdfa-44d20f3f3e7d  Disaster Recovery - ColdSite
#   5b1f3025-bad6-0c6f-4139-44d20f6b466f  Disaster Recovery - WarmSite
#   7db177ae-17b8-5baf-9140-44d20fe89917  Disaster Recovery - HotSite
#   bffbf962-2568-11df-0d76-44d2102c8e38  Other Contract
class SugarContractType < SugarDb
  set_table_name "contract_types"
end
