# Retrieves Sales Order information from Fishbowl, using a custom join on the
# Fishbowl side.
# ===Schema (read-only)
#   customer_name   string
#   customercontact string
#   customerpo      string
#   datecompleted   datetime
#   id              integer
#   num             string
#   salesman        string
#   shiptoaddress   string
#   shiptocity      string
#   shiptostate     string
#   shiptozip       string
#   team_name       string
class FishbowlSo < Fishbowl
  self.element_name = 'custom_sdops_so'
  self.collection_name = 'custom_sdops_so'

  include QuarterlyDates
  extend QuarterlyDates::ClassMethods

  def line_items
    begin
      @line_items ||= FishbowlSoItem.find(:all, :params => {:soid => self.id, :typeid => [10,11,12,30,31,80]})
    rescue ActiveResource::ResourceNotFound
      @line_items ||= []
    end
    @line_items
  end

  def self.received_last_quarter
    self.received_between(Quarter.beginning_of_last_quarter, Quarter.end_of_last_quarter)
  end
  def self.received_this_quarter
    self.received_between(Quarter.beginning_of_quarter, Quarter.end_of_quarter)
  end
  def self.received_between(beginning_of_q, end_of_q)
    begin
      x = self.find(:all, :params => {:datecreated_gt => beginning_of_q - 1.day, :datecreated_lt => end_of_q + 1.day})
    rescue ActiveResource::ResourceNotFound
      x = []
    end
    x
  end

  def revenue
    line_items.sum {|l| l.qtytofulfill * l.unitprice.to_f}
  end

  def quickbooks
    Quickbooks.profits_for_so(num)
  end
  def profit
    return BigDecimal('0.0') unless quickbooks
    quickbooks.profit
  end

  #Aliases to work with the old Appgen stuff:
  def cust_name
    customer_name
  end
  def ship_date
    datecompleted.to_date
  end
  def address2
    shiptoaddress
  end
  def address3
    shiptocity.to_s + ", " + shiptostate.to_s + " " + shiptozip.to_s
  end
  def address4
    ""
  end
  def sales_rep
    salesman
  end
  def net_discount
    nil
  end
  def cust_po_number
    customerpo
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