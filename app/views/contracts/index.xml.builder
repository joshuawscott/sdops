
xml.instruct!
xml.rows do  
  # rows
  for contract in @contracts
    xml.row :id => contract.id do
      xml.cell contract.sales_office_name
      xml.cell contract.support_office_name
      xml.cell contract.account_name
      xml.cell contract.said
      xml.cell contract.description
      xml.cell contract.cust_po_num
      xml.cell contract.payment_terms
      xml.cell contract.revenue
    end
  end
end
