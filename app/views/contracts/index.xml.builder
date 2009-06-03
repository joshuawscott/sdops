
xml.instruct!
xml.rows do  
  # rows
  @contracts.each do |contract|
    xml.row :id => contract.id do
      xml.cell contract.sales_office_name
      xml.cell contract.support_office_name
      xml.cell contract.account_name
      xml.cell contract.said
      xml.cell contract.description
      xml.cell contract.payment_terms
      xml.cell contract.start_date
      xml.cell contract.end_date
      xml.cell contract.total_revenue
    end
  end
end
