Factory.sequence(:counter) {|n| n }

Factory.define :commission do |c|
  c.user_id { Factory.next(:counter) }
  c.percentage '1.00'
  c.notes ''
end

