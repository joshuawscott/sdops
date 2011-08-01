Given /^the contract dropdowns are populated$/ do
  populate_dropdowns
end

Given /^I have created a contract$/ do
  create_contract
  Contract.count.should == 1
end

Given /^I am viewing that contract$/ do
  @contract = Contract.find(:first)
  visit contract_path(@contract)
  response.should contain("Contract ID")
  response.should contain("General Details")
  response.should contain("Show Contract")
end

Given /^some contracts exist to search on$/ do
  @contract1 = Factory(:dallas_contract, :description => 'contract the first', :said => 'first SAID', :sdc_ref => 'first SDC REF', :start_date => '2009-01-01', :end_date => '2009-01-31', :annual_hw_rev => 10000, :hw_support_level_id => "SDC 24x7", :sw_support_level_id => "SDC SW 24x7")
  @contract2 = Factory(:dallas_contract, :description => 'contract the second', :payment_terms => 'Monthly', :said => 'second SAID', :sdc_ref => 'second SDC REF', :start_date => '2009-02-01', :end_date => Date.today, :hw_support_level_id => "SDC 24x7", :sw_support_level_id => "SDC SW 24x7")
  @contract3 = Factory(:philadelphia_contract, :description => 'contract the third', :said => 'third SAID', :sdc_ref => 'third SDC REF', :hw_support_level_id => "SDC 24x7", :sw_support_level_id => "SDC SW 24x7")
  @contract4 = Factory(:philadelphia_contract, :description => 'contract the fourth', :payment_terms => 'Monthly', :said => 'fourth SAID', :sdc_ref => 'fourth SDC REF', :hw_support_level_id => "SDC 24x7", :sw_support_level_id => "SDC SW 24x7")
end

Given /^line items exist for those contracts$/ do
  Factory(:line_item, :serial_num => 'SERIAL11', :support_deal_id => @contract1.id)
  Factory(:line_item, :serial_num => 'SERIAL12', :support_deal_id => @contract1.id)
  Factory(:line_item, :serial_num => 'SERIAL21', :support_deal_id => @contract2.id)
  Factory(:line_item, :serial_num => 'SERIAL22', :support_deal_id => @contract2.id)
  Factory(:line_item, :serial_num => 'SERIAL31', :support_deal_id => @contract3.id)
  Factory(:line_item, :serial_num => 'SERIAL32', :support_deal_id => @contract3.id)
  Factory(:line_item, :serial_num => 'SERIAL41', :support_deal_id => @contract4.id)
  Factory(:line_item, :serial_num => 'SERIAL42', :support_deal_id => @contract4.id)
end

When /^I create a new contract$/ do
  response.should contain("New Contract")
  fill_in_contract_form
  click_button "Create"
end

When /^I change a contract detail$/ do
  fill_in "Description", :with => "My New Description"
  click_button "Update"
end

When /^I create a contract missing "([^\"]*)"$/ do |field|
  fill_in_contract_form
  fill_in "contract_" + field, :with => nil
  click_button "Create"
end

When /^I create a contract with "([^\"]*)" set to "([^\"]*)"$/ do |field, value|
  fill_in_contract_form
  fill_in "contract_" + field, :with => value
  click_button "Create"
end

When /^I visit the path for a contract outside my area$/ do
  visit "/contracts/#{@contract3.id}"
end

Then /^I should see a new contract$/ do
  response.should contain(/successfully/)
end

Then /^there should be (\d*) contracts?$/ do |number|
  Contract.count.should == number.to_i
end

Then /^I should see the new details$/ do
  response.should contain("My New Description")
end

