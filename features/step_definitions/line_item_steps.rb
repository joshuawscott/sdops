Given /^a contract exists$/ do
  populate_dropdowns if Dropdown.count == 0
  Factory(:user) if User.count == 0
  @contract = Factory(:contract)
  Contract.count.should == 1
end

Given /^I have created a line item$/ do
  @line_item = Factory(:line_item, :support_deal_id => @contract.id)
  @contract.line_items.count.should == 1
end

Given /^I have created 2 line items for that contract$/ do
  @line1 = Factory(:line_item, :support_provider => "Sourcedirect", :support_deal_id => @contract.id, :description => "First Lineitem Description")
  @line2 = Factory(:line_item, :support_provider => "Sourcedirect", :support_deal_id => @contract.id, :description => "Second Lineitem Description")
end

Given /^I am viewing its contract$/ do
  visit contract_path(@line_item.contract)
end

Given /^the line item is subcontracted$/ do
  @line_item.subcontract_id = @subcontract.id
  @line_item.save(false)
  @subcontract.line_items.count.should == 1
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

When /^I check 2 of the line item checkboxes$/ do
  check "licheckbox#{@line1.id.to_s}"
  check "licheckbox#{@line2.id.to_s}"
end

When /^I create a line item missing "([^\"]*)"$/ do |field|
  When "I fill out the line item form"
  fill_in "line_item_#{field}", :with => nil
  click_button 'Create'
end

When /^I create a line item with "([^\"]*)" set to "([^\"]*)"$/ do |field, value|
  When "I fill out the line item form"
  fill_in "line_item_#{field}", :with => value
  click_button 'Create'
end

When /^I check 1 of the line item checkboxes$/ do
  check "licheckbox#{@line1.id.to_s}"
end

Then /^I should see "([^\"]*)" in the line items$/ do |content|
  response.should have_selector('td', :content => content)
end

Then /^I should not see "([^\"]*)" in the line items$/ do |content|
  response.should_not have_selector('td', :content => content)
end

Then /^I should see 1 line item$/ do
  response.should contain("Second Lineitem Description")
  response.should_not contain("First Lineitem Description")
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

Then /^I should not see "([^\"]*)" for that line item$/ do |action|
  within("#lineitem_#{@line_item.id.to_s}") do |content|
    content.should_not contain(action)
  end
end