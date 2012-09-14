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
      xml.Column 'ss:Width' => '31.5' #ID
      xml.Column 'ss:Width' => '150' #Account Name
      xml.Column 'ss:Width' => '55' #Days Early
      xml.Column 'ss:Width' => '53.25' #Start Date
      xml.Column 'ss:Width' => '59' #PO Received
      xml.Column 'ss:Width' => '59.25' #Sales Office
      xml.Column 'ss:Width' => '84.75' #Sales Rep
      xml.Column 'ss:Width' => '84.75' #Primary CE
      xml.Column 'ss:Width' => '63' #Revenue

      # Header
      xml.Row do
        xml.Cell { xml.Data 'ID', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Account Name', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Days Early', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Start Date', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'PO Received', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Sales Office', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Sales Rep', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Primary CE', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Revenue', 'ss:Type' => 'String' }
      end

      # Rows
      @contracts.each do |contract|
        xml.Row do
          xml.Cell { xml.Data contract.id, 'ss:Type' => 'Number' }
          xml.Cell { xml.Data contract.account_name, 'ss:Type' => 'String' }
          xml.Cell { xml.Data contract.days_early, 'ss:Type' => 'Number' }
          xml.Cell 'ss:StyleID' => 'date' do
            xml.Data contract.start_date.to_xls_serial, 'ss:Type' => 'Number'
          end
          xml.Cell 'ss:StyleID' => 'date' do
            xml.Data contract.po_received.to_xls_serial, 'ss:Type' => 'Number'
          end
          xml.Cell { xml.Data contract.sales_office_name, 'ss:Type' => 'String' }
          xml.Cell { xml.Data contract.sales_rep.full_name, 'ss:Type' => 'String' }
          xml.Cell { xml.Data contract.primary_ce.nil? ? 'n/a' : contract.primary_ce.full_name, 'ss:Type' => 'String' }
          xml.Cell 'ss:StyleID' => 'currency' do
            xml.Data contract.revenue, 'ss:Type' => 'Number'
          end
        end
      end

    end
  end
end
