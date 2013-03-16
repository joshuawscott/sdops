Factory.define :line_item do |l|
  l.product_num 'A6144A'
  l.position 0
  l.location 'Dallas'
  l.support_type 'HW'
  l.begins Date.parse('2008-01-01')
  l.ends Date.parse('2008-12-31')
end

