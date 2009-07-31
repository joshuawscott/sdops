# Abstract Class for connecting to support_pricing DB
class SupportPricingDb < ActiveRecord::Base
  #establish_connection :support_pricing
  self.abstract_class = true

  validates_presence_of :modified_at
  validates_uniqueness_of :modified_at, :scope => :part_number
  before_validation :fix_date
  before_create :prevent_old_pricing

  # Returns many product records for searching purposes.  partnumber has a wildcard added to the end
  # and description has wildcards added to each side.
  def self.search(partnumber, description)
    return [] if partnumber == nil && description == nil
    self.find(:all,
      :conditions => "part_number LIKE '#{partnumber.gsub(/\\/, '\&\&').gsub(/'/, "''")}%' AND description like '%#{description.gsub(/\\/, '\&\&').gsub(/'/, "''")}%'",
      :group => "part_number ASC, confirm_date DESC, modified_at DESC",
      :limit => "1000")
  end

  # Returns most recently added product record that has a modification date before the quotedate.
  def self.getprice(partnumber, quotedate) #:nodoc:
    self.find(:all, :conditions => ["part_number = ? AND modified_at <= ? ", partnumber, quotedate], :order => 'modified_at DESC').first || self.new
  end

  # Returns a pricing object for the current date.
  def self.current_list_price(partnumber)
    self.getprice(partnumber, Time.now)
  end

  protected
  def fix_date
    self.modified_at = Date.parse('1970-01-01') if modified_at.nil?
    self.confirm_date = Date.parse('1970-01-01') if confirm_date.nil?
  end

  def prevent_old_pricing
    similar_records = self.class.count(:conditions => ["part_number = ? AND confirm_date >= ? AND confirm_date <> '1970-01-01'", self.part_number, self.confirm_date])
    logger.debug "number of similar records is #{similar_records}"
    similar_records == 0
  end
end
