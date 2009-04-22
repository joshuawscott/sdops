# Schema
#   id            integer
#   contract_id   integer
#   support_type  string
#   product_num   string
#   serial_num    string
#   description   string
#   begins        date
#   ends          date
#   qty           integer
#   list_price    decimal
#   created_at    datetime
#   updated_at    datetime
#   support_provider  string
#   position      integer
#   location      string
class LineItem < ActiveRecord::Base
  belongs_to :contract

  # Aggregates the locations in LineItems as an Array Object
  def self.locations(role,teams)
    if role >= MANAGER
      LineItem.find(:all, :select => 'location', :joins => :contract, :conditions => ['contracts.expired = ?', false]).map {|x| x.location}.uniq!.sort!
    else
      SugarTeam.dropdown_list(role,teams).map {|x| x.name}
    end
  end

  # OPTIMIZE: hw_revenue_by_location is VERY slow (>15 seconds)
  # Returns a collection of LineItem Objects with the total revenue for each location
  def self.hw_revenue_by_location
    locations = LineItem.find(:all, 
      :select => 'DISTINCT location, 0.0 as revenue', 
      :joins => :contract, 
      :conditions => ['contracts.expired = ?', false], 
      :order => :location)
    rawlist = LineItem.find(:all,
      :select => 'line_items.*, contracts.discount_pref_hw + contracts.discount_prepay + contracts.discount_multiyear AS discount, IFNULL(qty * list_price * 12 ,0.0) AS revenue',
      :joins => :contract,
      :conditions =>
        ['contracts.expired = :expired AND line_items.begins <= :begins AND line_items.ends >= :ends AND support_type = "HW"',
        {:expired => false, :begins => Time.now, :ends => Time.now}])
    locations.each do |l|
      rawlist.each  do |i|
        if l.location == i.location && i.revenue != nil && i.revenue.to_i > 0
          i.discount = i.contract.effective_hw_discount if i.discount.to_f == 0.0
          l.revenue = l.revenue.to_f + (i.revenue.to_f * (1 - i.discount.to_f))
        end
      end
    end
    locations
  end
end
