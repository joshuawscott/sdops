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

  xml.Worksheet 'ss:Name' => 'Renewal Business' do
    xml.Table do
      # Column Widths
      xml.Column 'ss:Width' => '53.25'
      xml.Column 'ss:Width' => '83.25'
      xml.Column 'ss:Width' => '212.25'
      xml.Column 'ss:StyleID' => 'description', 'ss:Width' => '235.25'
      xml.Column 'ss:Width' => '52.25'
      # Header
      xml.Row do
        xml.Cell 'ss:StyleID' => 'headers' do
          xml.Data 'PO Date', 'ss:Type' => 'String'
        end
        xml.Cell 'ss:StyleID' => 'headers' do
          xml.Data 'CBM', 'ss:Type' => 'String'
        end
        xml.Cell 'ss:StyleID' => 'headers' do
          xml.Data 'Account Name', 'ss:Type' => 'String'
        end
        xml.Cell 'ss:StyleID' => 'headers' do
          xml.Data 'Description', 'ss:Type' => 'String'
        end
        xml.Cell 'ss:StyleID' => 'headers' do
          xml.Data 'Revenue', 'ss:Type' => 'String'
        end
      end

      # Rows
      @contracts.each do |contract|
        if contract.period == params[:filter][:period]
          xml.Row do
            xml.Cell 'ss:StyleID' => 'date' do
              xml.Data contract.po_received.to_xls_serial, 'ss:Type' => 'Number'
            end
            xml.Cell { xml.Data contract.sales_rep_name, 'ss:Type' => 'String' }
            xml.Cell { xml.Data contract.account_name, 'ss:Type' => 'String' }
            xml.Cell { xml.Data contract.description, 'ss:Type' => 'String' }
            xml.Cell 'ss:StyleID' => 'currency' do
              xml.Data contract.tot_rev, 'ss:Type' => 'Number'
            end
          end
        end
      end

    end
  end
end
