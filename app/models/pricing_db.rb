class PricingDb < ActiveRecord::Base
  attr_accessor :list_price
  attr_accessor :description
  establish_connection :pricing

  def initialize(*params)
    super(*params)
    @list_price ||= 0.0
    @description ||= ''
  end

  def self.find_sun_pn(part_number)
    set_table_name :sun_en_svcs
    sun_pn = self.find(:first,
      :select => "sun_en_svcs.*, sun_en_hwsw.short_description",
      :conditions => {
        :mkt_part_number => part_number,
        :service_item_plan => ["GOLD-7X24-STK-SVC", "GOLD-SYS-SVC", "PREM-SW-SVC"]
      },
      :joins => "LEFT JOIN sun_en_hwsw ON sun_en_svcs.mkt_part_number=sun_en_hwsw.mkt_part_number") || PricingDb.new
    unless sun_pn.new_record?
      sun_pn.description = sun_pn.short_description
      if sun_pn.service_item_plan == "GOLD-SYS-SVC"
        sun_pn.list_price = sun_pn.oow_price * 0.6
      else
        sun_pn.list_price = sun_pn.oow_price
      end
    end
    sun_pn
  end

  def self.find_hp_pn(part_number, options={})
    type = options.delete("type")
    set_table_name "99ShortDescr".to_sym
    hp_pn = self.find(:first,
      :select => "99ShortDescr.product_number, 99ShortDescr.description AS `desc`, support.option_number",
      :joins => "LEFT JOIN support ON 99ShortDescr.product_number=support.product_number",
      :conditions => ["99ShortDescr.product_number = ?", part_number]) || PricingDb.new
    unless hp_pn.new_record?
      hp_pn.description = hp_pn.desc
      #find the 1, 3, and 4year prices for the option number & calc an approximate price
      sup_pn = type == 'hw' ? 'HA104A' : 'HA107A'
      year1 = self.find_by_sql("SELECT price1 from USUDDPprice WHERE product_number = '#{sup_pn}1     #{hp_pn.option_number}'")[0]
      year3 = self.find_by_sql("SELECT price1 from USUDDPprice WHERE product_number = '#{sup_pn}3     #{hp_pn.option_number}'")[0]
      year4 = self.find_by_sql("SELECT price1 from USUDDPprice WHERE product_number = '#{sup_pn}4     #{hp_pn.option_number}'")[0]
      if year4
        hp_pn.list_price = (BigDecimal.new(year4.price1) - BigDecimal.new(year3.price1))/BigDecimal.new("12")
      else
        hp_pn.list_price = (BigDecimal.new(year3.price1) - BigDecimal.new(year1.price1))/BigDecimal.new("24")
      end
    end
    hp_pn
  end

end

