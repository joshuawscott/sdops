Factory.sequence(:date) {|n| Date.today + n.days }

Factory.define :hw_support_price do |p|
  p.part_number "A6144A"
  p.description "L3000 Server"
  p.modified_at { Factory.next(:date) }
  p.confirm_date { Factory.next(:date) }
end
