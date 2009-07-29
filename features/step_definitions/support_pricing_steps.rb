Given /^some support products exist$/ do
  Factory(:hw_support_price, :part_number => 'A6144A', :description => 'L3000')
  Factory(:hw_support_price, :part_number => 'A6144B', :description => 'L3000')
  Factory(:sw_support_price, :part_number => 'A6144A', :description => 'L3000')
  Factory(:hw_support_price, :part_number => 'A5522A', :description => 'Processor')
  Factory(:sw_support_price, :part_number => 'A5522A', :description => 'Processor')
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

