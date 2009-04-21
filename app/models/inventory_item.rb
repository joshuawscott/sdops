class InventoryItem < ActiveRecord::Base
  def tracking
    self.id
  end
end
