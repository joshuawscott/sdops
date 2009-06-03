
xml.instruct!
xml.Workbook({
  'xmlns'      => "urn:schemas-microsoft-com:office:spreadsheet", 
  'xmlns:o'    => "urn:schemas-microsoft-com:office:office",
  'xmlns:x'    => "urn:schemas-microsoft-com:office:excel",    
  'xmlns:html' => "http://www.w3.org/TR/REC-html40",
  'xmlns:ss'   => "urn:schemas-microsoft-com:office:spreadsheet" 
  }) do

  xml.Worksheet 'ss:Name' => 'Contracts' do
    xml.Table do

      # Header
      xml.Row do
          xml.Cell { xml.Data 'Sales Office', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Support Office', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Account Name', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'SAID', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Description', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Start Date', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'End Date', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Terms', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Annual Rev', 'ss:Type' => 'String' }
      end

      # Rows
      @contracts.each do |contract|
        xml.Row do
            xml.Cell { xml.Data contract.sales_office_name, 'ss:Type' => 'String' }
            xml.Cell { xml.Data contract.support_office_name, 'ss:Type' => 'String' }
            xml.Cell { xml.Data contract.account_name, 'ss:Type' => 'String' }
            xml.Cell { xml.Data contract.said, 'ss:Type' => 'String' }
            xml.Cell { xml.Data contract.description, 'ss:Type' => 'String' }
            xml.Cell { xml.Data contract.start_date, 'ss:Type' => 'String' }
            xml.Cell { xml.Data contract.end_date, 'ss:Type' => 'String' }
            xml.Cell { xml.Data contract.payment_terms, 'ss:Type' => 'String' }
            xml.Cell { xml.Data contract.total_revenue, 'ss:Type' => 'Number' }
        end
      end

    end
  end
end
