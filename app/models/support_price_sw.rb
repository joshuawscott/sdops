class SupportPriceSw < SupportPricingDb
  #Schema:
  #id integer
  #part_number string
  #description string
  #phone_price decimal
  #update_price decimal
  #modified_by STRING
  #modified_at DATE
  #confirm_date DATE
  #notes TEXT
  
  set_table_name "swdb"

  # SupportPriceSw.search -- Returns many product records for searching purposes
  def self.search(partnumber, description, quotedate)
    return [] if partnumber.nil? && description.nil?
    SupportPriceSw.find(:all,
      :select => "id, part_number, description, phone_price + update_price as list_price, modified_at, confirm_date", 
      :conditions => ["part_number LIKE '#{partnumber.gsub(/\\/, '\&\&').gsub(/'/, "''")}%' AND description like '%#{description.gsub(/\\/, '\&\&').gsub(/'/, "''")}%' AND modified_at <= ?", quotedate],
      :group => "part_number ASC, confirm_date ASC, modified_at ASC",
      :limit => "1000")
  end

  # SupportPriceSw.getprice -- Returns the product record for quoting purposes
  #--
  #FIXME: SupportPriceSW.getprice doesn't work correctly
  # original query from quoter tool:
  #SELECT part_number, description, list_price FROM 
  #   (SELECT part_number,description,phone_price + update_price AS list_price,modified_at FROM swdb 
  #   WHERE modified_at <= "$contractdate" 
  #   AND part_number "$partnumber" 
  #   ORDER BY modified_at DESC) as t2
  #GROUP BY part_number
  def self.getprice(partnumber, quotedate)
    return [] if partnumber.nil?
    SupportPriceSw.find(:first,
      :select => "id, part_number, description, phone_price + updates_price as list_price, modified_at, confirm_date", 
      :conditions => ["part_number = '#{partnumber.gsub(/\\/, '\&\&').gsub(/'/, "''")}' AND modified_at <= ?", quotedate],
      :group => "part_number ASC, confirm_date DESC, modified_at DESC")
  end

  # SupportPriceSw.currentprice -- convenience method for getprice with a quotedate of Time.now
  def self.currentprice(partnumber)
    SupportPriceSw.getprice(partnumber, Time.now)
  end

end
