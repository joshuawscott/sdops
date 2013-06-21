
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

  xml.Worksheet 'ss:Name' => 'UnearnedRevenue' do
    xml.Table do

      # Header
      xml.Row do
        xml.Cell { xml.Data 'Contract ID', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Account Name', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Payment Terms', 'ss:Type' => 'String' }
        @date_headers.each do |month|
          xml.Cell 'ss:StyleID' => 'date' do
            xml.Data month.to_xls_serial, 'ss:Type' => 'Number'
          end
        end
      end

      # Rows
      @contracts.each do |contract|
        xml.Row do
          xml.Cell { xml.Data contract.id, 'ss:Type' => 'Number' }
          xml.Cell { xml.Data contract.account_name, 'ss:Type' => 'String' }
          xml.Cell { xml.Data contract.payment_terms, 'ss:Type' => 'String' }
          contract.unearned_revenue_schedule_array(:start_date => Date.parse(@start_date), :end_date => Date.parse(@end_date)).each do |payment_schedule|
            xml.Cell 'ss:StyleID' => 'currency' do
              xml.Data payment_schedule.to_f.round(4), 'ss:Type' => 'Number'
            end
          end
        end
      end
    end
  end
end
