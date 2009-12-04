Given /^(\d*) inventory items exist$/ do |number|
  number.to_i.times do |n|
    Factory(:inventory_item,
      :id => "ID100#{n.to_s}",
      :item_code => "A500#{n.to_s}",
      :description => "Item Number #{n}",
      :serial_number => "ABC#{n}",
      :warehouse => "W#{n}",
      :location => "LOC#{n}",
      :manufacturer => "MFG#{n}")
  end
end

Given /^(\d*) "([^\"]+)" inventory items exist$/ do |number,warehouse|
  number.to_i.times do |n|
    Factory(:inventory_item,
      :id => "ID100#{n.to_s}",
      :item_code => "A500#{n.to_s}",
      :description => "Item Number #{n}",
      :warehouse => warehouse)
  end
end

Given /^warehouse "([^\"]*)" is "([^\"]*)"$/ do |code, description|
  Factory(:inventory_warehouse, :code => code, :description => description)
end

Given /^a contract and line items exist for comparison$/ do
  @contract = Factory(:contract)
  @contract.line_items << Factory(:line_item, :product_num => 'A5001')
  @contract.line_items << Factory(:line_item, :product_num => 'A5002')
  @contract.line_items << Factory(:line_item, :product_num => 'A5002')
  @contract.line_items << Factory(:line_item, :product_num => 'A5004')
  @contract.line_items << Factory(:line_item, :product_num => 'A5004')
  @contract.line_items << Factory(:line_item, :product_num => 'A5004')
  @contract.line_items << Factory(:line_item, :product_num => 'A5004')
end

