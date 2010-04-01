
xml.instruct!
xml.Workbook({
  'xmlns'      => "urn:schemas-microsoft-com:office:spreadsheet",
  'xmlns:o'    => "urn:schemas-microsoft-com:office:office",
  'xmlns:x'    => "urn:schemas-microsoft-com:office:excel",
  'xmlns:html' => "http://www.w3.org/TR/REC-html40",
  'xmlns:ss'   => "urn:schemas-microsoft-com:office:spreadsheet"
  }) do

  xml.Worksheet 'ss:Name' => 'Line Items' do
    xml.Table do

      # Header
      xml.Row do
          xml.Cell { xml.Data 'Type', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Support Provider', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Support Location', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Product Number', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Note', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Description', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Serial Number', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Begins', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Ends', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Qty', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'List Price', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Ext. Price', 'ss:Type' => 'String' }
      end

      # Rows
      @line_items.each do |lineitem|
        xml.Row do
            xml.Cell { xml.Data lineitem.support_type, 'ss:Type' => 'String' }
            xml.Cell { xml.Data lineitem.support_provider, 'ss:Type' => 'String' }
            xml.Cell { xml.Data lineitem.location, 'ss:Type' => 'String' }
            xml.Cell { xml.Data lineitem.product_num, 'ss:Type' => 'String' }
            xml.Cell { xml.Data lineitem.note, 'ss:Type' => 'String' }
            xml.Cell { xml.Data lineitem.description, 'ss:Type' => 'String' }
            xml.Cell { xml.Data lineitem.serial_num, 'ss:Type' => 'String' }
            xml.Cell { xml.Data lineitem.begins, 'ss:Type' => 'String' }
            xml.Cell { xml.Data lineitem.ends, 'ss:Type' => 'String' }
            xml.Cell { xml.Data lineitem.qty, 'ss:Type' => 'String' }
            xml.Cell { xml.Data lineitem.list_price, 'ss:Type' => 'Number' }
            xml.Cell { xml.Data lineitem.ext_list_price, 'ss:Type' => 'Number' }
        end
      end

    end
  end
end
