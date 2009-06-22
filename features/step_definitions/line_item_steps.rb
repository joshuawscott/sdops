Given /^a contract exists$/ do
  @contract = Factory(:contract)
  Contract.count.should == 1
end

Given /^I have created a line item$/ do
  @line_item = Factory(:line_item, :contract_id => @contract.id)
  @contract.line_items.count.should == 1
end

Given /^I am viewing its contract$/ do
  visit contract_path(@line_item.contract)
end

When /^I fill out the line item form$/ do
  fill_in 'Product num', :with => 'A6144A'
  fill_in 'Description', :with => 'STRANGE BREW'
  fill_in 'Qty', :with => 1
  fill_in 'List Price', :with => 483.00
end

When /^I follow "([^\"]*)" for that line item$/ do |action|
  click_link_within "#lineitem_#{@line_item.id.to_s}", action
end

When /^I change a line item detail$/ do
  fill_in 'Description', :with => 'Brand Spanking New Description'
  click_button 'Update'
end

Then /^I should see the new line item$/ do
  response.should contain("STRANGE BREW")
end

Then /^I should see the new line item details$/ do
  response.should contain('Brand Spanking New Description')
end

Then /^I should be see its contract$/ do
  response.should contain(@contract.id.to_s)
  response.should contain(@contract.account_name.to_s)
end

Then /^I should not see that line item$/ do
  response.should_not contain("STRANGE BREW")
end

