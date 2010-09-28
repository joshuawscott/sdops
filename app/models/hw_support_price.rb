# Schema:
#   id            integer
#   part_number   string
#   description   string
#   list_price    decimal
#   modified_by   string
#   modified_at   date
#   confirm_date  date
#   notes         text
class HwSupportPrice < SupportPricingDb

  set_table_name "hwdb"
  validates_presence_of :part_number, :description, :list_price, :manufacturer_line_id

  belongs_to :manufacturer_line
end
