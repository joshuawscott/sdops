# Schema:
#   id            integer
#   part_number   string
#   description   string
#   phone_price   decimal
#   update_price  decimal
#   modified_by   string
#   modified_at   date
#   confirm_date  date
#   notes         text
class SupportPriceSw < SupportPricingDb
  
  set_table_name "swdb"

  # Returns many product records for searching purposes
  def self.search(partnumber, description, quotedate)
    return [] if partnumber.nil? && description.nil?
    SupportPriceSw.find(:all,
      :select => "id, part_number, description, phone_price, update_price, modified_at, confirm_date", 
      :conditions => ["part_number LIKE '#{partnumber.gsub(/\\/, '\&\&').gsub(/'/, "''")}%' AND description like '%#{description.gsub(/\\/, '\&\&').gsub(/'/, "''")}%' AND modified_at <= ?", quotedate],
      :group => "part_number ASC, confirm_date ASC, modified_at ASC",
      :limit => "1000")
  end

  # Returns the product record for quoting purposes
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
      :select => "id, part_number, description, phone_price, update_price, modified_at, confirm_date", 
      :conditions => ["part_number = '#{partnumber.gsub(/\\/, '\&\&').gsub(/'/, "''")}' AND modified_at <= ?", quotedate],
      :group => "part_number ASC, confirm_date DESC, modified_at DESC")
  end

  # Convenience method for getprice with a quotedate of Time.now
  def self.currentprice(partnumber)
    SupportPriceSw.getprice(partnumber, Time.now)
  end

  # Returns part_number, description, phone_price, update_price for the current date.
  def self.current_list_price(item)
    self.find_by_sql(["SELECT part_number, description, phone_price, update_price FROM
      (SELECT part_number,description,phone_price, update_price,modified_at FROM swdb
        WHERE part_number = ?
        ORDER BY modified_at DESC) as t2
        GROUP BY part_number LIMIT 1", item])[0] || self.new
  end

  # Returns phone_price + update_price (convenience method for quoting)
  def list_price
    unless phone_price.nil? || update_price.nil?
      phone_price + update_price
    else
      BigDecimal.new('0.0')
    end
  end
end
