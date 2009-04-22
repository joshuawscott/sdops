class InventoryItem < ActiveRecord::Base
  # convenience method for the id field
  def tracking
    self.id
  end
end
