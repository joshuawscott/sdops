Given /^some contracts exist$/ do
  @contract_1 = Factory(:contract, :expired => 1, :start_date => "2008-02-01", :end_date => "2009-01-31" )
  @contract_2 = Factory(:contract, :expired => 1, :start_date => "2008-02-01", :end_date => "2009-01-31" )
  @contract_3 = Factory(:contract, :start_date => "2009-02-01", :end_date => "2010-01-31" )
  @contract_4 = Factory(:contract, :start_date => "2008-06-01", :end_date => "2009-05-31" )

  @contract_2.successors << @contract_3
  @contract_3.predecessors << @contract_2
end


