Factory.define :subcontract do |s|
  @subcontractor = Subcontract.find(:first) || Factory(:subcontractor)
  s.subcontractor_id @subcontractor.id
  s.start_date Date.parse('2009-01-01')
  s.end_date Date.parse('2009-12-31')
end
