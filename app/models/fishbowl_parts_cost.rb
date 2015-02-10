class FishbowlPartsCost < Fishbowl
  self.element_name = 'custom_parts_cost'
  self.collection_name = 'custom_parts_cost'

  def self.cost_for(contract_id)
    self.find(contract_id)
  end

  def contract_id
    name.split(' - ').first
  end

  def cost
    BigDecimal.new(sum.to_s)
  end
end