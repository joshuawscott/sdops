class SupportPriceHw < SupportPricingDb
  #Schema:
  #id integer
  #part_number string
  #description string
  #list_price decimal
  #modified_by STRING
  #modified_at DATE
  #confirm_date DATE
  #notes TEXT
  
  set_table_name "hwdb"

  # SupportPriceHw.search -- Returns many product records for searching purposes
  def self.search(partnumber, description, quotedate)
    return [] if partnumber == nil && description == nil
    SupportPriceHw.find(:all,
      :select => "id, part_number, description, list_price, modified_at, confirm_date", 
      :conditions => ["part_number LIKE '#{partnumber.gsub(/\\/, '\&\&').gsub(/'/, "''")}%' AND description like '%#{description.gsub(/\\/, '\&\&').gsub(/'/, "''")}%' AND modified_at <= ?", quotedate],
      :group => "part_number ASC, confirm_date DESC, modified_at DESC",
      :limit => "1000")
  end

  # SupportPriceHw.getprice -- Returns the product record for quoting purposes
  #--
  #FIXME: SupportPriceHw.getprice doesn't work correctly
  # original query from quoter tool:
  #SELECT part_number, description, list_price FROM 
  #   (SELECT part_number,description,list_price,modified_at FROM hwdb 
  #   WHERE modified_at <= "$contractdate" 
  #   AND part_number "$partnumber" 
  #   ORDER BY modified_at DESC) as t2
  #GROUP BY part_number
  def self.getprice(partnumber, quotedate) #:nodoc:
    return [] if partnumber == nil
    SupportPriceHw.find(:first,
      :select => "id, part_number, description, list_price, modified_at, confirm_date", 
      :conditions => ["part_number = '#{partnumber.gsub(/\\/, '\&\&').gsub(/'/, "''")}' AND modified_at <= ?", quotedate],
      :group => "part_number ASC, confirm_date DESC, modified_at DESC")
  end

  # SupportPriceHw.currentprice -- convenience method for getprice with a quotedate of Time.now
  def self.currentprice(partnumber) #:nodoc:
    SupportPriceHw.getprice(partnumber, Time.now)
  end

end
