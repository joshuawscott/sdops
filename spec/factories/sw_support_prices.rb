Factory.sequence(:date) {|n| Date.today + n.days }

Factory.define :sw_support_price do |p|
  p.part_number "A6144A"
  p.description "L3000 Server"
  p.modified_at { Factory.next(:date) }
  p.confirm_date { Factory.next(:date) }
  p.manufacturer_line_id 1
  p.phone_price 0.0
  p.update_price 0.0
end
