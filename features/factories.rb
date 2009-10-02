gem 'thoughtbot-factory_girl'
require 'factory_girl'

Factory.define :user do |u|
  u.login 'bob'
  @sugar_user ||= SugarUser.find(:first, :conditions => 'user_name = "bobdallas"')
  u.first_name 'bob'
  u.last_name 'smith'
  u.password 'secret'
  u.password_confirmation { |p| p.password }
  u.office 'Dallas'
  u.email 'bdallas@example.com'
  u.sugar_id { SugarUser.find(:first, :conditions => "user_name = '#{@sugar_user.user_name}'").id }
end

Factory.define :dropdown do |d|
  d.dd_name ''
  d.label ''
  d.filter ''
  d.sort_order 0
end

Factory.define :contract do |c|
  @sugar_team = SugarTeam.find_by_name('Dallas')
  @sugar_account = SugarAcct.find(:first, :conditions => "team_id = '#{@sugar_team.id}'")
  c.account_name @sugar_account.name
  c.account_id @sugar_account.id
  c.sales_office @sugar_team.id
  c.support_office @sugar_team.id
  c.sales_office_name @sugar_team.name
  c.support_office_name @sugar_team.name
  c.sales_rep_id { User.find(:first).id }
  c.start_date "2009-01-01"
  c.end_date "2009-12-31"
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
end

Factory.define :dallas_contract, :class => :contract do |c|
  @sugar_team = SugarTeam.find_by_name('Dallas')
  @sugar_account = SugarAcct.find(:first, :conditions => "team_id = '#{@sugar_team.id}'")
  c.account_name @sugar_account.name
  c.account_id @sugar_account.id
  c.sales_office @sugar_team.id
  c.support_office @sugar_team.id
  c.sales_office_name @sugar_team.name
  c.support_office_name @sugar_team.name
  c.sales_rep_id { User.find(:first).id }
  c.start_date "2009-01-01"
  c.end_date "2009-12-31"
  c.annual_hw_rev 50
  c.annual_sw_rev 40
  c.annual_sa_rev 30
  c.annual_ce_rev 20
  c.annual_dr_rev 10
  c.platform {Dropdown.find(:first, :conditions => {:dd_name => 'platform'} ).label }
  c.payment_terms { Dropdown.find(:first, :conditions => {:dd_name => 'payment_terms'}).label }
  c.po_received '2008-12-15'
  c.said 'foo'
  c.revenue 150
  c.sdc_ref 'bar'
end

Factory.define :philadelphia_contract, :class => :contract do |c|
  @sugar_team = SugarTeam.find_by_name('Philadelphia')
  @sugar_account = SugarAcct.find(:first, :conditions => "team_id = '#{@sugar_team.id}'")
  c.account_name @sugar_account.name
  c.account_id @sugar_account.id
  c.sales_office @sugar_team.id
  c.support_office @sugar_team.id
  c.sales_office_name @sugar_team.name
  c.support_office_name @sugar_team.name
  c.sales_rep_id { User.find(:first).id }
  c.start_date "2009-01-01"
  c.end_date "2009-12-31"
  c.annual_hw_rev 50
  c.annual_sw_rev 40
  c.annual_sa_rev 30
  c.annual_ce_rev 20
  c.annual_dr_rev 10
  c.platform {Dropdown.find(:first, :conditions => {:dd_name => 'platform'} ).label }
  c.payment_terms { Dropdown.find(:first, :conditions => {:dd_name => 'payment_terms'}).label }
  c.po_received '2008-12-15'
  c.said 'foo'
  c.revenue 150
  c.sdc_ref 'bar'
end

Factory.define :line_item do |l|
  l.product_num 'A6144A'
  l.position 0
  l.location 'Dallas'
  l.support_type 'HW'
end

Factory.define :comment do |c|
end

Factory.define :inventory_item do |i|
end

Factory.define :inventory_warehouse do |i|
end

Factory.sequence(:date) {|n| Date.today + n.days }

Factory.define :hw_support_price do |h|
  h.modified_at { Factory.next(:date) }
  h.confirm_date { Factory.next(:date) }
end

Factory.define :sw_support_price do |s|
  s.modified_at { Factory.next(:date) }
  s.confirm_date { Factory.next(:date) }
end

Factory.define :subcontractor do |s|
end

Factory.define :subcontract do |s|
  s.subcontractor_id { @subcontractor.id }
  s.start_date Date.parse('2009-01-01')
  s.end_date Date.parse('2009-12-31')
end
