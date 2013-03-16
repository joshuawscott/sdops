#module Kernel
  def d(date)
    Date.parse_date(date)
  end
def past_date_string
  @past_date_string ||= (Date.today - 6.months).to_s
end
def future_date_string
  @future_date_string ||= (Date.today + 6.months).to_s
end

#end
