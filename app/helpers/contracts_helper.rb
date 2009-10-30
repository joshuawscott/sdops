module ContractsHelper
  # outputs a link to a subcontract if present.  Otherwise just returns the support provider name
  # usage:
  #  <%- support_provider(line_item)%>
  def support_provider(line_item)
    if line_item.subcontract_id.nil?
      haml_concat line_item.support_provider
    else
      haml_concat(link_to(line_item.subcontract.subcontractor.name, contract_line_item_path(@contract, line_item)))
    end
  end
  
  def set_page(options={})
    @page_description = options[:description]
    @page_subheader = options[:subheader]
    @page_num += 1
    puts "setting page #{@page_num}"
  end

end

