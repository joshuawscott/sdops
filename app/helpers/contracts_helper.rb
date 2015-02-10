module ContractsHelper
  # outputs a link to a subcontract if present.  Otherwise just returns the support provider name
  # usage:
  #  <%- support_provider(line_item)%>
  def support_provider(line_item)
    if line_item.subcontract_id.nil?
      haml_concat line_item.support_provider
    else
      if line_item.subcontract.nil?
        haml_concat "ERROR"
      else
        haml_concat(link_to(line_item.subcontract.subcontractor.name, contract_line_item_path(@contract, line_item)))
      end
    end
  end

  def set_page(options={})
    @page_description = options[:description]
    @page_subheader = options[:subheader]
    @page_num += 1
    #puts "setting page #{@page_num}"
  end

  def print_payment_option(num, opts={:multiyear => false, :prepay => false})
    #debugger
    original_font = @pdf.font
    multiyear = opts[:multiyear]
    prepay = opts[:prepay]

    # Construct the description of the given discounts
    if multiyear && prepay
      discount_string = "Includes Multi Year and PrePay Discounts"
      hw_discount_breakdown = "HW = " + number_to_percentage(@contract.discount_pref_hw * 100, :precision => 0) + ", Mult = " + number_to_percentage(@contract.discount_multiyear * 100, :precision => 0) + ", PrePay = " + number_to_percentage(@contract.discount_prepay * 100, :precision => 0)
      sw_discount_breakdown = "SW = " + number_to_percentage(@contract.discount_pref_sw * 100, :precision => 0) + ", Mult = " + number_to_percentage(@contract.discount_multiyear * 100, :precision => 0) + ", PrePay = " + number_to_percentage(@contract.discount_prepay * 100, :precision => 0)
      srv_discount_breakdown = "SRV = " + number_to_percentage(@contract.discount_pref_srv * 100, :precision => 0) + ", Mult = " + number_to_percentage(@contract.discount_multiyear * 100, :precision => 0) + ", PrePay = " + number_to_percentage(@contract.discount_prepay * 100, :precision => 0)
    elsif multiyear
      discount_string = "Includes Multi Year Discount"
      hw_discount_breakdown = "HW = " + number_to_percentage(@contract.discount_pref_hw * 100, :precision => 0) + ", Mult = " + number_to_percentage(@contract.discount_multiyear * 100, :precision => 0)
      sw_discount_breakdown = "SW = " + number_to_percentage(@contract.discount_pref_sw * 100, :precision => 0) + ", Mult = " + number_to_percentage(@contract.discount_multiyear * 100, :precision => 0)
      srv_discount_breakdown = "SRV = " + number_to_percentage(@contract.discount_pref_srv * 100, :precision => 0) + ", Mult = " + number_to_percentage(@contract.discount_multiyear * 100, :precision => 0)
    elsif prepay
      discount_string = "Includes PrePay Discount"
      hw_discount_breakdown = "HW = " + number_to_percentage(@contract.discount_pref_hw * 100, :precision => 0) + ", PrePay = " + number_to_percentage(@contract.discount_prepay * 100, :precision => 0)
      sw_discount_breakdown = "SW = " + number_to_percentage(@contract.discount_pref_sw * 100, :precision => 0) + ", PrePay = " + number_to_percentage(@contract.discount_prepay * 100, :precision => 0)
      srv_discount_breakdown = "SRV = " + number_to_percentage(@contract.discount_pref_srv * 100, :precision => 0) + ", PrePay = " + number_to_percentage(@contract.discount_prepay * 100, :precision => 0)
    else
      discount_string = "Includes Preferred Customer Discount Only"
      hw_discount_breakdown = "HW = " + number_to_percentage(@contract.discount_pref_hw * 100, :precision => 0)
      sw_discount_breakdown = "SW = " + number_to_percentage(@contract.discount_pref_sw * 100, :precision => 0)
      srv_discount_breakdown = "SRV = " + number_to_percentage(@contract.discount_pref_srv * 100, :precision => 0)
    end

    hw_discount_rate = @contract.discount(:type => 'hw', :multiyear => multiyear, :prepay => prepay)
    sw_discount_rate = @contract.discount(:type => 'sw', :multiyear => multiyear, :prepay => prepay)
    srv_discount_rate = @contract.discount(:type => 'srv', :multiyear => multiyear, :prepay => prepay)

    hw_discount_string = number_to_percentage(hw_discount_rate * 100, :precision => 0)
    sw_discount_string = number_to_percentage(sw_discount_rate * 100, :precision => 0)
    srv_discount_string = number_to_percentage(srv_discount_rate * 100, :precision => 0)

    #banner
    @pdf.font("Helvetica-Bold")
    @pdf.table [["Option #{num.to_s} (#{discount_string})"]], :row_colors => ["F2F2F2"], :font_size => 12, :border_width => 0, :width => @full_wide, :row_height => 18

    #row titles
    @pdf.table [["", "", "List\nPrice", "Discount\nRate", "Discount\nAmount", "Contract Price", prepay ? "" : "Monthly Price"]], {:font_size => 8, :align => :center, :column_widths => @pod_widths, :border_width => 0, :vertical_padding => 0, :horizontal_padding => 0}
    @pdf.font("Helvetica", :size => 10)

    # data
    hw_contract_price = @hw_list_price - @contract.discount_amount(:type => 'hw', :prepay => prepay, :multiyear => multiyear)
    sw_contract_price = @sw_list_price - @contract.discount_amount(:type => 'sw', :prepay => prepay, :multiyear => multiyear)
    srv_contract_price = @srv_list_price - @contract.discount_amount(:type => 'srv', :prepay => prepay, :multiyear => multiyear)
    @pdf.table [["Hardware Support Pricing", hw_discount_breakdown, number_to_currency(@hw_list_price), hw_discount_string, number_to_currency(-@contract.discount_amount(:type => "hw", :multiyear => multiyear, :prepay => prepay)), number_to_currency(hw_contract_price), prepay ? "" : "see sched."]], {:align => {0 => :left, 1 => :left, 2 => :right, 3 => :right, 4 => :right, 5 => :right, 6 => :right, 7 => :right}, :font_size => 10, :column_widths => @pod_widths, :border_width => 0, :vertical_padding => 0, :horizontal_padding => 0}
    @pdf.table [["Software Support Pricing", sw_discount_breakdown, number_to_currency(@sw_list_price), sw_discount_string, number_to_currency(-@contract.discount_amount(:type => "sw", :multiyear => multiyear, :prepay => prepay)), number_to_currency(sw_contract_price), prepay ? "" : "see sched."]], {:align => {0 => :left, 1 => :left, 2 => :right, 3 => :right, 4 => :right, 5 => :right, 6 => :right, 7 => :right}, :font_size => 10, :column_widths => @pod_widths, :border_width => 0, :vertical_padding => 0, :horizontal_padding => 0}
    @pdf.table [["Services Pricing", srv_discount_breakdown, number_to_currency(@srv_list_price), srv_discount_string, number_to_currency(-@contract.discount_amount(:type => "srv", :multiyear => multiyear, :prepay => prepay)), number_to_currency(srv_contract_price), prepay ? "" : "see sched."]], {:align => {0 => :left, 1 => :left, 2 => :right, 3 => :right, 4 => :right, 5 => :right, 6 => :right, 7 => :right}, :font_size => 10, :column_widths => @pod_widths, :border_width => 0, :vertical_padding => 0, :horizontal_padding => 0}
    @pdf.move_down 7

    @pdf.font(original_font.attributes["fullname"])
  end

  # takes a number and converts to a percentage with extra zeros stripped.
  # .50 => 50%
  # .3612 => 36.12%
  # .123456789 => 12.34%
  def discount_to_percentage(number, options ={})
    options[:strip_digits] = true if options[:strip_digits].nil?
    options[:precision] = 2 if options[:precision].nil?

    number ||= 0.0
    if options[:strip_digits] == true
      number_to_percentage(number * 100.0, :precision => options[:precision]).gsub(/0*%$/, '%').gsub(/\.%/, '%')
    else
      number_to_percentage(number * 100.0, :precision => options[:precision])
    end
  end

end
