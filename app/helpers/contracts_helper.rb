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

  def print_payment_option(num, opts={:multi_year => false, :pre_pay => false})
    #debugger
    original_font = @pdf.font
    multi_year = opts[:multi_year]
    pre_pay = opts[:pre_pay]


    if multi_year && pre_pay
      discount_string = "Includes Multi Year and PrePay Discounts"
    elsif multi_year
      discount_string = "Includes Multi Year Discount"
    elsif pre_pay
      discount_string = "Includes PrePay Discount"
    else
      discount_string = "Includes Prefered Customer Discount Only"
    end

    #banner
    @pdf.font("Helvetica-Bold")
    @pdf.table [["Option #{num.to_s} (#{discount_string})"]], :row_colors => ["F2F2F2"], :font_size => 12, :border_width => 0, :width => @full_wide, :row_height => 18

    #row titles
    @pdf.table [["","", "List\nPrice", "Discount\nRate", "Discount\nAmount", "Contract Price", pre_pay ? "" : "Monthly Price"]], {:font_size => 8, :align => :center, :column_widths => @pod_widths, :border_width => 0, :vertical_padding => 0, :horizontal_padding => 0}
    @pdf.font("Helvetica", :size => 10)

    # data
    @pdf.table [["Hardware Support Pricing","HW = 44%, Mult = 5%, PrePay = 4%", "$4,872.00", "53%", "$(2,582.16)", "$2,289.84", pre_pay ? "" : "$190.82"]], {:align => {0 => :left, 1 => :left, 2 => :right, 3 => :right, 4 => :right, 5 => :right, 6 => :right, 7 => :right}, :font_size => 10, :column_widths => @pod_widths, :border_width => 0, :vertical_padding => 0, :horizontal_padding => 0}
    @pdf.table [["Software Support Pricing","SW = 44%, Mult = 5%, PrePay = 4%", "$4,872.00", "53%", "$(2,582.16)", "$2,289.84", pre_pay ? "" : "$190.82"]], {:align => {0 => :left, 1 => :left, 2 => :right, 3 => :right, 4 => :right, 5 => :right, 6 => :right, 7 => :right}, :font_size => 10, :column_widths => @pod_widths, :border_width => 0, :vertical_padding => 0, :horizontal_padding => 0}
    @pdf.table [["Services Pricing","SW = 44%, Mult = 5%, PrePay = 4%", "$4,872.00", "53%", "$(2,582.16)", "$2,289.84", pre_pay ? "" : "$190.82"]], {:align => {0 => :left, 1 => :left, 2 => :right, 3 => :right, 4 => :right, 5 => :right, 6 => :right, 7 => :right}, :font_size => 10, :column_widths => @pod_widths, :border_width => 0, :vertical_padding => 0, :horizontal_padding => 0}
    @pdf.move_down 7

    @pdf.font(original_font.attributes["fullname"])
  end
end

