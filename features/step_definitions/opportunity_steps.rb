When /^I create a new opportunity$/ do
  response.should contain("New Opportunity")
  fill_in_opportunity_form
  click_button "Create"
end

Then /^there should be 1 opportunity$/ do
  pending
end

Then /^I should see a new opportunity$/ do
  pending
end

