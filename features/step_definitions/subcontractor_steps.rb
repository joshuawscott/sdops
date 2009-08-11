Given /^a subcontractor exists$/ do
  @subcontract = Factory :subcontractor, :name => "subkspecial"
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

