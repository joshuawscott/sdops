# ===Schema
#   id            integer
#   part_number   string
#   description   string
#   phone_price   decimal
#   update_price  decimal
#   modified_by   string
#   modified_at   date
#   confirm_date  date
#   notes         text
# See SupportPricingDb for most methods.
class SwSupportPrice < SupportPricingDb

  set_table_name "swdb"
  validates_presence_of :part_number, :description, :phone_price, :update_price, :manufacturer_line_id

  # Returns +phone_price+ + +update_price+ (convenience method for quoting)
  def list_price
    self.phone_price ||= BigDecimal.new('0.0')
    self.update_price ||= BigDecimal.new('0.0')
    phone_price + update_price
  end
end
