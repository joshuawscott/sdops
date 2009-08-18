Factory.define :subcontract do |s|
  s.subcontractor_id { Subcontractor.find(:first).id }
  s.start_date Date.parse('2009-01-01')
  s.end_date Date.parse('2009-12-31')
end
