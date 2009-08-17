Then /^The page should load successfully$/ do
  debugger
end

When /^I visit (.+)$/ do |url|
  visit url
end

Then /^I should still see the menu$/ do
  %w(Contracts Reports Tools Prices Logout).each do |value|
    response.should contain(value)
  end
end

Then /^I should see "([^\"]*)" within "([^\"]*)"$/ do |value, field|
  response.should have_selector(field) do |f|
    f.should contain(value)
  end
end


