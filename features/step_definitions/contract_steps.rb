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
end

When /^I create a new contract$/ do
  response.should contain("New Contract")
  fill_in_contract_form
  click_button "Create"
end

When /^I change a detail$/ do
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

Then /^I should see a new contract$/ do
  response.should contain(/successfully/)
end

Then /^there should be (\d*) contracts?$/ do |number|
  Contract.count.should == number.to_i
end

Then /^I should see the new details$/ do
  response.should contain("My New Description")
end

