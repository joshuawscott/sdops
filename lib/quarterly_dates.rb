module QuarterlyDates
  module ClassMethods
    def quarter_to_dates(year, quarter)
      [nil,
        [Date.new(year,  1, 1), Date.new(year,  3, 31)],
        [Date.new(year,  4, 1), Date.new(year,  6, 30)],
        [Date.new(year,  7, 1), Date.new(year,  9, 30)],
        [Date.new(year, 10, 1), Date.new(year, 12, 31)]][quarter]
    end
  end
  class Quarter
    def self.beginning_of_quarter(date = Date.today)
      month = [nil, 1,1,1, 4,4,4, 7,7,7, 10,10,10][date.month]
      "#{date.year}-#{month}-01".to_date
    end
    def self.end_of_quarter(date = Date.today)
      month = [nil, 3,3,3, 6,6,6, 9,9,9, 12,12,12][date.month]
      "#{date.year}-#{month}-01".to_date.end_of_month
    end
    def self.beginning_of_last_quarter(date = Date.today)
      self.beginning_of_quarter(date.months_ago(3))
    end
    def self.end_of_last_quarter(date = Date.today)
      self.end_of_quarter(date.months_ago(3))
    end
    def self.beginning_of_next_quarter(date = Date.today)
      self.beginning_of_quarter(date.months_since(3))
    end
    def self.end_of_next_quarter(date = Date.today)
      self.end_of_quarter(date.months_since(3))
    end
  end
end
class Date
  def to_quarter_number
    ((self.month + 2) / 3)
  end
  def to_quarter_string
    "Q#{self.to_quarter_number} #{self.year}"
  end
  def beginning_of_quarter

  end
end
