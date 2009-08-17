Given /^a subcontractor exists$/ do
  @subcontractor = Factory :subcontractor, :name => "subkspecial"
  Subcontractor.count.should == 1
end

When /^I follow "([^\"]*)" in the subcontractors table$/ do |link|
  response.should have_selector("table#subcontractors") do |t|
    t.should have_tag("tbody") do |b|
      b.should have_tag("tr") do |tr|
        tr.should have_tag("td") do |td|
          td.should have_tag("a") do |a|
            a.should contain(link)
          end
        end
      end
    end
  end
  click_link_within "#subcontractors", link

end

Given /^a subcontract exists$/ do
  @subcontract = Factory :subcontract, :subcontractor_id => @subcontractor.id
  Subcontract.count.should == 1
end

When /^I follow "([^\"]*)" in the subcontracts table$/ do |link|
  click_link_within "#subcontracts", link
end

Then /^I should see the subcontract form$/ do
  response.should have_tag("div#subcontract")
  response.should have_tag("div#line_items")
  response.should have_tag("div#subcontractor_search")
end

When /^I find a subcontract$/ do
  select "subkspecial", :from => "Subcontractor"
  click_button "Find Subcontracts"
  response.should contain("subkspecial")
end

