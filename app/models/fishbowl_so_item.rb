# Individual line items from a FishbowlSo
# ===Schema (read-only)
#   adjustamount      integer
#   adjustpercentage  decimal
#   description       string
#   id                integer
#   productid         integer
#   productnum        string
#   qtyshipped        integer
#   qtytofulfill      integer
#   serialnum         string
#   soid              integer
#   solineitem        integer
#   totalcost         decimal
#   typeid            integer
#   unitprice         decimal
#
class FishbowlSoItem < Fishbowl
  self.element_name = 'custom_sdops_so_item'
  self.collection_name = 'custom_sdops_so_item'

  def hwchecked
    return "false" if part_number.blank?
    # if it's a discount, unchecked
    return "false" unless part_number.match(/^[0-9][0-9]\%$/).nil?
    # if it's an SDC number, unchecked
    return "false" unless part_number.match(/^SDC/).nil?
    # if the first letter is A, then it's checked
    return "true" if [65, 67, 68, 69].include?(part_number[0])
    # if the first part is a number, then it's checked
    return "true" if (part_number[0] >= 48 && part_number[0] <= 57)
    #default checked
    'true'
  end

  def swchecked
    # if the first letter is B, then it's checked
    return "true" if part_number[0] == 66
    # if the first letter is T, then it's checked
    return "true" if part_number[0] == 84
    'false'
  end

  #Aliases to work with AppgenOrderLineitem
  def part_number
    productnum
  end

  def quantity
    # was qtytofulfill, but all qtys are 1 due to 100% serial number tracking in fishbowl.
    1
  end

  def price
    unitprice
  end

  def discount
    "-$" + adjustamount.to_s + " OR " + (adjustpercentage * 100).to_s + "%"
  end

  # columns method to imitate ActiveRecord functionality
  def self.columns
    example_record = self.find(:first) #need to make this find(:first)
    col_names = example_record.attributes.keys
    @columns = []
    col_names.each do |cn|
      @columns << ActiveRecord::ConnectionAdapters::Column.new(cn, nil)
    end
    @columns
  end
end