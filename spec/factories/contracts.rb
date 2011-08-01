Factory.sequence(:counter) {|n| n }

Factory.define :contract do |c|
  @sugar_team = SugarTeam.find_by_name('Dallas')
  @sugar_account = SugarAcct.find(:first, :conditions => "team_id = '#{@sugar_team.id}'")
  c.account_name @sugar_account.name
  c.account_id { Factory.next(:counter) }
  c.sales_office { Factory.next(:counter) }
  c.support_office { Factory.next(:counter) }
  c.sales_office_name "Dallas"
  c.support_office_name "Dallas"
  c.sales_rep_id { Factory.next(:counter) }
  c.start_date "2011-01-01"
  c.end_date "2011-12-31"
  c.annual_hw_rev 50
  c.annual_sw_rev 40
  c.annual_sa_rev 30
  c.annual_ce_rev 20
  c.annual_dr_rev 10
  c.platform 'HP9000/Integrity'
  c.payment_terms 'Annual'
  c.po_received '2008-12-15'
  c.said 'foo'
  c.revenue 150
  c.sdc_ref 'bar'
  c.hw_support_level_id "SDC 24x7"
  c.sw_support_level_id "SDC SW 24x7"
  c.discount_pref_hw 0.0
  c.discount_pref_sw 0.0
  c.discount_pref_srv 0.0
  c.discount_prepay 0.0
  c.discount_multiyear 0.0
  c.discount_ce_day 0.0
  c.discount_sa_day 0.0
end

Factory.define :phoenix_contract, :class => :contract do |c|
  @sugar_team = SugarTeam.find_by_name('Phoenix')
  @sugar_account = SugarAcct.find(:first, :conditions => "team_id = '#{@sugar_team.id}'")
  c.account_name @sugar_account.name
  c.account_id { Factory.next(:counter) }
  c.sales_office { Factory.next(:counter) }
  c.support_office { Factory.next(:counter) }
  c.sales_office_name "Phoenix"
  c.support_office_name "Phoenix"
  c.sales_rep_id { Factory.next(:counter) }
  c.start_date "2011-01-01"
  c.end_date "2011-12-31"
  c.annual_hw_rev 50
  c.annual_sw_rev 40
  c.annual_sa_rev 30
  c.annual_ce_rev 20
  c.annual_dr_rev 10
  c.platform 'HP9000/Integrity'
  c.payment_terms 'Annual'
  c.po_received '2008-12-15'
  c.said 'foo'
  c.revenue 150
  c.sdc_ref 'bar'
  c.hw_support_level_id "SDC 24x7"
  c.sw_support_level_id "SDC SW 24x7"
  c.discount_pref_hw 0.0
  c.discount_pref_sw 0.0
  c.discount_pref_srv 0.0
  c.discount_prepay 0.0
  c.discount_multiyear 0.0
  c.discount_ce_day 0.0
  c.discount_sa_day 0.0
end


