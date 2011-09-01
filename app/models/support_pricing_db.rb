# Abstract Class for connecting to support_pricing DB, and to store common
# methods to both the HwSupportPrice and SwSupportPrice models.
class SupportPricingDb < ActiveRecord::Base
  #establish_connection :support_pricing
  self.abstract_class = true

  validates_presence_of :modified_at
  validates_uniqueness_of :modified_at, :scope => :part_number
  before_validation :fix_date
  before_create :prevent_old_pricing

  # Returns many product records for searching purposes.  partnumber has a
  # wildcard added to the end and description has wildcards added to beginning
  # and end.
  def self.search(partnumber, description)
    return [] if partnumber == nil && description == nil
    description ||= ""
    self.find(:all,
      :conditions => "part_number LIKE '#{partnumber.gsub(/\\/, '\&\&').gsub(/'/, "''")}%' AND description like '%#{description.gsub(/\\/, '\&\&').gsub(/'/, "''")}%'",
      :limit => "1000")
  end

  # Returns most recently added product record that has a modification date
  # before the quotedate.  Allows retrieval of historical prices.
  def self.getprice(partnumber, quotedate)
    self.find(:all, :conditions => ["part_number = ? AND modified_at <= ? ", partnumber, quotedate], :order => 'modified_at DESC').first || self.new
  end

  # Returns a pricing object for the current date.
  def self.current_list_price(partnumber)
    self.getprice(partnumber, Date.today)
  end

  protected
  # Sets modified_at date 1970-01-01 if this is the first time that part number
  # has been added.  Otherwise, set to today's date.
  def fix_date
    if self.class.count(:conditions => {:part_number => self.part_number}) > 0
      self.modified_at ||= Date.today
    end
    self.modified_at ||= Date.parse('1970-01-01')
    self.confirm_date ||= Date.parse('1970-01-01')
  end

  # Prevents saving a record that has an old +confirm_date+
  def prevent_old_pricing
    similar_records = self.class.count(:conditions => ["part_number = ? AND confirm_date >= ? AND confirm_date <> '1970-01-01'", self.part_number, self.confirm_date])
    logger.debug "number of similar records is #{similar_records}"
    similar_records == 0
  end

  # Sets the modified_at date to 5 hours ago (UTC-5)
  def set_modified_at_to_today
    #TODO: Timezone checks
    self.modified_at = 5.hours.ago
  end

  # Alias for manufacturer_line.manufacturer.
  def manufacturer
    manufacturer_line.manufacturer
  end
end
