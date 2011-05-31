
xml.instruct!
xml.Workbook({
  'xmlns'      => "urn:schemas-microsoft-com:office:spreadsheet",
  'xmlns:o'    => "urn:schemas-microsoft-com:office:office",
  'xmlns:x'    => "urn:schemas-microsoft-com:office:excel",
  'xmlns:html' => "http://www.w3.org/TR/REC-html40",
  'xmlns:ss'   => "urn:schemas-microsoft-com:office:spreadsheet"
  }) do

  xml.Styles do
    xml.Style 'ss:ID' => 'Default', 'ss:Name' => 'Normal' do
      xml.Alignment 'ss:Vertical' => 'Bottom'
      xml.Borders
      xml.Font
      xml.Interior
      xml.NumberFormat
      xml.Protection
    end
    xml.Style 'ss:ID' => 'description' do
      xml.Alignment 'ss:Vertical' => 'Bottom', 'ss:WrapText' => '1'
    end
    xml.Style 'ss:ID' => 'headers' do
      xml.Font 'ss:Bold' => '1'
    end
    xml.Style 'ss:ID' => 'currency' do
      xml.NumberFormat 'ss:Format' => '"$"#,##0.00'
    end
    xml.Style 'ss:ID' => 'date' do
      xml.NumberFormat 'ss:Format' => 'Short Date'
    end
  end

  xml.Worksheet 'ss:Name' => 'Contracts' do
    xml.Table do
      xml.Column 'ss:Width' => '59.25' #Sales Office
      xml.Column 'ss:Width' => '150' #Account Name
      xml.Column 'ss:Width' => '180' #Description
      xml.Column 'ss:Width' => '53.25' #Start Date
      xml.Column 'ss:Width' => '53.25' #End Date
      xml.Column 'ss:Width' => '65.25' #Renewal Sent
      xml.Column 'ss:Width' => '63' #Revenue
      xml.Column 'ss:Width' => '63' #Renewal Est.
      xml.Column 'ss:Width' => '300' #Comment

      # Header
      xml.Row do
        xml.Cell { xml.Data 'Sales Office', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Account Name', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Description', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Start Date', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'End Date', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Renewal Sent', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Revenue', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Renewal Est.', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Comment', 'ss:Type' => 'String' }
      end

      # Rows
      @contracts.each do |contract|
        xml.Row do
          xml.Cell { xml.Data contract.sales_office_name, 'ss:Type' => 'String' }
          xml.Cell { xml.Data contract.account_name, 'ss:Type' => 'String' }
          xml.Cell { xml.Data contract.description, 'ss:Type' => 'String' }
          xml.Cell 'ss:StyleID' => 'date' do
            xml.Data contract.start_date.to_xls_serial, 'ss:Type' => 'Number'
          end
          xml.Cell 'ss:StyleID' => 'date' do
            xml.Data contract.end_date.to_xls_serial, 'ss:Type' => 'Number'
          end
          if contract.renewal_sent.nil?
            xml.Cell { xml.Data "N/A", 'ss:Type' => 'String' }
          else
            xml.Cell 'ss:StyleID' => 'date' do
              xml.Data contract.renewal_sent.nil? ? "N/A" : contract.renewal_sent.to_xls_serial, 'ss:Type' => 'Number'
            end
          end
          xml.Cell 'ss:StyleID' => 'currency' do
            xml.Data contract.revenue, 'ss:Type' => 'Number'
          end
          xml.Cell 'ss:StyleID' => 'currency' do
            xml.Data contract.renewal_amount, 'ss:Type' => 'Number'
          end
          if contract.last_comment.nil?
            xml.Cell { xml.Data "", 'ss:Type' => 'String' }
          else
            xml.Cell { xml.Data contract.last_comment.body, 'ss:Type' => 'String' }
          end
        end
      end

    end
  end
end
