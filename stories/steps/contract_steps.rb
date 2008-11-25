steps_for(:contract) do

  Given "admin is logged in" do
    post "/sessions", :login => 'admin', :password => 'test'
  end

  When "I create a new contract" do
    post "/contracts",  "contract" => {"cust_po_num"=>"cust po",
                                       "annual_sa_rev"=>"1004",
                                       "annual_dr_rev"=>"1005",
                                       "discount_ce_day"=>"5",
                                       "hw_support_level_id"=>"3",
                                       "start_date"=>"1/1/2008",
                                       "end_date"=>"12/31/2008",
                                       "sales_office"=>"11",
                                       "annual_hw_rev"=>"1001",
                                       "annual_sw_rev"=>"1002",
                                       "sw_support_level_id"=>"6",
                                       "account_id"=>"cust",
                                       "discount_pref_hw"=>"1",
                                       "discount_pref_sw"=>"2",
                                       "discount_multiyear"=>"4",
                                       "payment_terms"=>"16",
                                       "support_office"=>"11",
                                       "updates"=>"false",
                                       "platform"=>"false",
                                       "description"=>"descript",
                                       "annual_ce_rev"=>"1003",
                                       "replacement_sdc_ref"=>"",
                                       "discount_prepay"=>"3",
                                       "multiyr_end"=>"",
                                       "sa_days"=>"0",
                                       "sales_rep_id"=>"1",
                                       "discount_sa_day"=>"6",
                                       "ce_days"=>"0",
                                       "expired"=>"false",
                                       "sdc_ref"=>"123",
                                       "revenue"=>"1000"}
  end
  
  Then "the contract should in database" do
    Contract.find_by_cust_po_num("cust po").should_not be_nil
    @id = Contract.find_by_cust_po_num("cust po").id
  end
  
  Then "should redirect to show page" do
    response.should redirect_to("/contracts/#{@id}")
  end

end
