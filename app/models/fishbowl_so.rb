class FishbowlSo < Fishbowl
  self.element_name = 'custom_sdops_so'
  self.collection_name = 'custom_sdops_so'

  def line_items
    begin
      @line_items = FishbowlSoItem.find(:all, :params => {:soid => self.id, :typeid => [10,11,12,30,31,80]})
    rescue ActiveResource::ResourceNotFound
      @line_items = []
    end
    @line_items
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