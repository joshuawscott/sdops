@c_ids = Contract.find(:all, :select => :id).map do |x|
	x.id
end
t = Time.now
@c_ids.each do |c|
	Contract.find(c).update_line_item_effective_prices
end
puts Time.now - t
