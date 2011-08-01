Given /^the product lines are populated$/ do
  @mfg = Factory(:manufacturer, :name => "HP")
  @mfg_line = Factory(:manufacturer_line, :name => "Proliant", :manufacturer_id => @mfg.id)
end

Given /^some support products exist$/ do
  Factory(:hw_support_price, :part_number => 'A6144A', :description => 'L3000', :list_price => 0.0, :manufacturer_line_id => @mfg_line.id)
  Factory(:hw_support_price, :part_number => 'A6144B', :description => 'L3000', :list_price => 0.0, :manufacturer_line_id => @mfg_line.id)
  Factory(:sw_support_price, :part_number => 'A6144A', :description => 'L3000', :phone_price => 0.0, :update_price => 0.0, :manufacturer_line_id => @mfg_line.id)
  Factory(:hw_support_price, :part_number => 'A5522A', :description => 'Processor', :list_price => 0.0, :manufacturer_line_id => @mfg_line.id)
  Factory(:sw_support_price, :part_number => 'A5522A', :description => 'Processor', :phone_price => 0.0, :update_price => 0.0, :manufacturer_line_id => @mfg_line.id)
  HwSupportPrice.count.should == 3
  SwSupportPrice.count.should == 2
end

Then /^I should see the HW support price add form$/ do
  response.should have_tag("form[action='/hw_support_prices']") do |form|
    form.should have_tag("label[for=hw_support_price_part_number]") do |label|
      label.should contain("Product Number")
    end
    form.should have_tag("label[for=hw_support_price_description]") do |label|
      label.should contain("Description")
    end
    form.should have_tag("label[for=hw_support_price_list_price]") do |label|
      label.should contain("List Price")
    end
    form.should have_tag("label[for=hw_support_price_confirm_date]") do |label|
      label.should contain("Confirmation Date")
    end
  end
end

Then /^I should see the SW support price add form$/ do
  response.should have_tag("form[action='/sw_support_prices']") do |form|
    form.should have_tag("label[for=sw_support_price_part_number]") do |label|
      label.should contain("Product Number")
    end
    form.should have_tag("label[for=sw_support_price_description]") do |label|
      label.should contain("Description")
    end
    form.should have_tag("label[for=sw_support_price_phone_price]") do |label|
      label.should contain("Phone Price")
    end
    form.should have_tag("label[for=sw_support_price_update_price]") do |label|
      label.should contain("Update Price")
    end
    form.should have_tag("label[for=sw_support_price_confirm_date]") do |label|
      label.should contain("Confirmation Date")
    end
  end
end

Then /^I should see "([^\"]*)" inside the support search results$/ do |text|
  response.should have_tag("table") do |table|
    table.should have_tag("tbody") do |tbody|
      tbody.should contain(text)
    end
  end
end

When /^I follow "([^\"]*)" next to the support search results$/ do |link|
  response.should have_tag("table") do |table|
    table.should have_tag("tbody") do |tbody|
      click_link link
    end
  end
end

When /^I search for (.*) Support Price "([^\"]*)"$/ do |type,part_number|
  click_link "#{type} Support Pricing"
  fill_in "Part Number", :with => part_number
  click_button "Search"
end

