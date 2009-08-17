module ContractsHelper #:nodoc:
  def support_provider(line_item)
    if line_item.subcontract_id.nil?
      haml_concat line_item.support_provider
    else
      haml_concat(link_to(line_item.subcontract.subcontractor.name, contract_line_item_path(@contract, line_item)))
    end
  end
end
