@pdf = pdf
# Set default global font
pdf.font("Helvetica", :size => 10)

# Some convenient variables, full wide is the full page width in PDF points, half_wide is half width.
@full_wide = (pdf.bounds.right - pdf.bounds.left).to_i
half_wide = ((pdf.bounds.right - pdf.bounds.left) / 2).to_i

# widths for the line item detail section.
line_detail_widths = { 0 => 88, 1 => 92, 2 => 217, 3 => 75, 4 => 47, 5 => 47, 6 => 29, 7 => 60, 8 => 65}

# to force a new page to start, we would do something like this:
#   pdf.start_new_page
#   set_page :description => "lorem", :subheader => "ipsum"
# The set_page method increments the page number, 
# and also sets the @page_description and @page_subheader variables.
# We set them initially here:
@page_description = "Support Quote Overview"
@page_subheader = nil
@page_num = 1

# This is executed for each page, so it will set the header height
# differently for the line item detail pages.
if @page_description.match('Line Item Detail') != nil
  table_header_height = 20
  table_header = true
else
  table_header_height = 0
  table_header = false
end

# Set the header for the overview here.  We override this later for the detail pages, though.
pdf.header pdf.margin_box.top_left, :height => 80, :width => @full_wide do
  pdf.bounding_box [pdf.bounds.left + 10 ,pdf.bounds.top], :width => half_wide - 10 do
    pdf.image("public/images/SODI-LOGO-TAG-padded.png", :position => :left, :scale => 0.22)
  end
  pdf.bounding_box [pdf.bounds.left + half_wide,pdf.bounds.top - 20], :width => half_wide do
    pdf.text "Source Direct Global HQ\n4555 Excel Parkway, Suite 500\nAddison, TX 75001\n877-503-9800", :size => 8, :align => :right
  end
  pdf.bounding_box([pdf.bounds.left,pdf.bounds.top - 80], :width => 250) do
    pdf.text @page_description, :size => 16, :style => :bold
    pdf.text @page_subheader, :size => 12, :style => :bold
  end
  pdf.bounding_box([pdf.bounds.left + 250, pdf.bounds.top - 80], :width => pdf.bounds.right - 250, :height => 20) do
    pdf.text "Support Agreement ID (SAID): " + @contract.said, :align => :right, :style => :bold, :size => 11
  end
  pdf.bounding_box([pdf.bounds.left + 250, pdf.bounds.top - 100], :width => pdf.bounds.right - 250) do
    pdf.text "SourceDirect Reference Number: " + @contract.sdc_ref, :align => :right, :style => :bold, :size => 11
  end
end

# Setting the footer up.
pdf.footer [0,pdf.bounds.bottom], :height => 20, :width => @full_wide do
  pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], :height => 20, :width => half_wide + 100 do
    pdf.text "4555 Excel Parkway, Suite 500 - Addison, TX 75001 - 972-239-4680 - www.sourcedirect.com", :size => 8
  end
  pdf.bounding_box [half_wide + 100, pdf.bounds.top], :height => 20, :width => half_wide - 100 do
    pdf.text "Page " + @page_num.to_s, :size => 8, :align => :right
  end
end

#####################
### BEGIN CONTENT ###
#####################

# Quoted prices are valid x days from today
# TODO: Make the 90 days a variable, which can be set from the quoting screen
pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 130], :width => 300) do
  pdf.text "The quoted prices are valid for 90 days from " + Date.today.to_s, :style => :bold, :size => 11
end

# For Support, Please call...
pdf.fill_color "7CBA48"
pdf.font("Helvetica-Bold")
pdf.table [["For Support, please call: 877-503-9800"]], :row_colors => ["F2F2F2"], :font_size => 18, :border_width => 0, :width => @full_wide, :row_height => 31
pdf.fill_color "000000"
pdf.font("Helvetica")

pdf.bounding_box [0,pdf.cursor - 3], :width => @full_wide do
  pdf.text "Support Agreement ID: " + @contract.said, :size => 12, :style => :bold
end

# Customer Address area
pdf.bounding_box([0, pdf.cursor - 20], :width => half_wide, :height => 75) do
  pdf.text "Customer Address:", :style => :bold
  pdf.text @contract.address1
  pdf.text @contract.address2
  pdf.text @contract.address3
end

# Source Direct Contact area
pdf.bounding_box([half_wide, pdf.cursor + 75], :width => 300, :height => 75) do
  pdf.text "Source Direct Contact:", :style => :bold
  pdf.text @contract.address1
  pdf.text @contract.address2
  pdf.text @contract.address3
end

# Customer Contact area
pdf.bounding_box([0, pdf.cursor], :width => half_wide, :height => 75) do
  pdf.text "Customer Contact:", :style => :bold
  pdf.text @contract.address1
  pdf.text @contract.address2
  pdf.text @contract.address3
  #pdf.stroke_bounds
end

# Contract Term Box
pdf.fill_color "F2F2F2"
pdf.rectangle([pdf.bounds.right - 160, pdf.cursor + 85], 160, 65); pdf.fill
pdf.fill_color "000000"
pdf.bounding_box([pdf.bounds.right - 160, pdf.cursor + 85], :width => 160, :height => 65) do
  pdf.move_down 2
  pdf.text "Contract", :align => :center, :style => :bold, :size => 11
  pdf.move_down 2
  pdf.text "Term", :align => :center, :style => :bold, :size => 11
  pdf.line_width 1.5 
  pdf.stroke_line [2, 33, 158, 33]
  pdf.line_width 1
  pdf.move_down 7
  pdf.text "From: " + @contract.start_date.to_s(:local), :align => :center, :style => :bold, :size => 11
  pdf.move_down 1
  pdf.text "To: " + @contract.end_date.to_s(:local), :align => :center, :style => :bold, :size => 11
  pdf.stroke_bounds
end
pdf.move_down(10)
#TODO: Set the @terms from the database (quoting interface)
@terms = "Total excludes all taxes; however, taxes will be added at the time of invoicing at the current tax rate.
Total price includes all discount and adjustments if applicable.
Subject to Source Direct terms and conditions of Sale and Service
This is line 4
This is line 5"

# Pricing Summary Box
pdf.font("Helvetica-Bold")
pdf.text "Summary of Charges"
pdf.fill_color "F2F2F2"
pdf.rectangle([0,pdf.cursor], @full_wide, 100); pdf.fill
pdf.fill_color "000000"
pdf.bounding_box [0,pdf.cursor], :width => @full_wide, :height => 100 do
  pdf.line_width = 1.5

  #Above the Total Price
  pdf.bounding_box [114,pdf.bounds.top], :width => @full_wide - 114, :height => 45 do
    services = ""
    services += " Hardware " if @contract.hw_support_level_id != "None"
    services += " Software " if @contract.sw_support_level_id != "None"
    services += " Services" if @contract.ce_days + @contract.sa_days + @contract.annual_ce_rev + @contract.annual_sa_rev + @contract.annual_dr_rev > 0
    pdf.bounding_box [0,pdf.bounds.top], :width => @full_wide - 314, :height => 45 do
      pdf.pad_top(6) {pdf.text "Total Annual Contract List Price - " + services}#, :at => [0,30]
      pdf.pad_top(6) {pdf.text "Total Effective Customer Discount (See Option 1)"}#, :at => [0,12]
    end
    pdf.bounding_box [400, pdf.bounds.top], :width => 200, :height => 45 do
      
      #Contract List Price
      pdf.pad_top(6) {pdf.text number_to_currency(@contract.total_list_price), :align => :right}

      #Discount Amount (negative)
      pdf.pad_top(6) {pdf.text number_to_currency(0.0 - @best_discount_amount), :align => :right}
    end
  end

  # Total Price line
  pdf.bounding_box [114, pdf.cursor], :width => @full_wide - 114, :height => 20 do
    pdf.bounding_box [0,pdf.bounds.top], :width => @full_wide - 314, :height => 20 do
      pdf.pad_top(6) {pdf.indent(2) {pdf.text "Total Source Direct Support & Services Annual Contract Price"}}
    end
    pdf.bounding_box [400,pdf.bounds.top], :width => 200, :height => 20 do 
      # Bottom Line price with best discount.
      pdf.pad_top(6) {pdf.text number_to_currency(@contract.total_list_price - @best_discount_amount), :align => :right}
    end
    pdf.stroke_bounds
  end
  pdf.text "For detail and additional payment options see page 3", :at => [114, 10]

  pdf.stroke_bounds
  pdf.line_width = 1
end
pdf.font("Helvetica")


pdf.move_down 3
pdf.text @terms, :size => 10

###########################
### SUPPORT DESCRIPTION ###
###########################

pdf.start_new_page
set_page :description => "Support Description", :subheader => ""
pdf.move_down 130
pdf.font("Helvetica-Bold")
pdf.table [["Hardware Support\nService Level", "Description", "Software Support\nService Level", "Description"]], {:border_style => :grid, :row_colors => ["F2F2F2"], :font_size => 10, :border_width => 1, :row_height => 31, :column_widths => {0 => 120, 1 => 240, 2 => 120, 3 => 240}}
pdf.font("Helvetica")
pdf.table [[@contract.hw_support_level_id, @contract.hw_support_description, @contract.sw_support_level_id, @contract.sw_support_description]], {:font_size => 10, :border_width => 0, :row_height => 31, :column_widths => {0 => 120, 1 => 240, 2 => 120, 3 => 240}}

#######################
### PAYMENT OPTIONS ###
#######################

pdf.start_new_page
set_page :description => "Payment Options Details", :subheader => ""
pdf.move_down 130
#TODO: Base the options shown on the selected options
annual_option = true
monthly_option = true
multi_year_annual_option = true
multi_year_monthly_option = true
payment_option_number = 0
@pod_widths = {0 => 177, 1 => 196, 2 => 75, 3 => 47, 4 => 75, 5 => 75, 6 => 75}

hw_text = "Hardware Support Pricing"
hw_discount = "HW = #{number_to_percentage(@contract.discount_pref_hw * 100, :precision => 0)}"
sw_text = "Software Support Pricing"

blank_cell = Prawn::Table::Cell.new(:document => pdf, :text => "", :align => :center, :horizontal_padding => 0, :vertical_padding => 0, :font_style => :bold, :width => 0)
list_price_cell = Prawn::Table::Cell.new(:document => pdf, :text => "List\nPrice", :align => :center, :horizontal_padding => 0, :vertical_padding => 0, :font_style => :bold, :width => 0)
disc_rate_cell = Prawn::Table::Cell.new(:document => pdf, :text => "Discount\nRate", :align => :center, :horizontal_padding => 0, :vertical_padding => 0, :font_style => :bold, :width => 0)
disc_amt_cell = Prawn::Table::Cell.new(:document => pdf, :text => "Discount\nAmount", :align => :center, :horizontal_padding => 0, :vertical_padding => 0, :font_style => :bold, :width => 0)
contract_price_cell = Prawn::Table::Cell.new(:document => pdf, :text => "Contract Price", :align => :center, :horizontal_padding => 0, :vertical_padding => 0, :font_style => :bold, :width => 0)
monthly_price_cell = Prawn::Table::Cell.new(:document => pdf, :text => "Monthly Price", :align => :center, :horizontal_padding => 0, :vertical_padding => 0, :font_style => :bold, :width => 0)


if multi_year_annual_option
  payment_option_number += 1
  print_payment_option(payment_option_number, :multiyear => true, :prepay => true)
end

if multi_year_monthly_option
  payment_option_number += 1
  print_payment_option(payment_option_number, :multiyear => true, :prepay => false)
end

if annual_option
  payment_option_number += 1
  print_payment_option(payment_option_number, :multiyear => false, :prepay => true)
end

if monthly_option
  payment_option_number += 1
  print_payment_option(payment_option_number, :multiyear => false, :prepay => false)
end

########################
### PAYMENT SCHEDULE ###
########################

pdf.start_new_page
set_page :description => "Monthly Payment Schedule", :subheader => ""
pdf.move_down 130
normal_payment_schedule = @contract.payment_schedule()
multiyear_payment_schedule = @contract.payment_schedule(:multiyear => true)
###################  spacer       Date          Multiyear     spacer      normal
column_widths     = {0 => 150,    1 => 80,      2 => 100,     3 => 20,    4 => 100    }
column_alignments = {0 => :left,  1 => :left,   2 => :center, 3 => :left, 4 => :center}
pdf.table([["", "Date", "with Multiyear", "", "Monthly"]], {:horizontal_padding => 0, :vertical_padding => 5, :font_size => 12, :border_width => 0, :row_height => 25, :align => column_alignments, :column_widths => column_widths})
normal_payment_schedule.size.times do |month|
  if month == 24
    pdf.start_new_page
    set_page :description => "Monthly Payment Schedule", :subheader => "(continued)"
    pdf.move_down 130
    pdf.table([["", "Date", "with Multiyear", "", "Monthly"]], {:horizontal_padding => 0, :vertical_padding => 5, :font_size => 12, :border_width => 0, :row_height => 25, :align => column_alignments, :column_widths => column_widths})
  end
  date = month == 0 ? @contract.start_date : Date.new(@contract.start_date.>>(month).year,@contract.start_date.>>(month).month,1)
  pdf.table([["", date, number_to_currency(multiyear_payment_schedule[month]), "", number_to_currency(normal_payment_schedule[month])]], {:padding => 0, :font_size => 10, :border_width => 0, :row_height => 20, :align => column_alignments, :column_widths => column_widths})
end

########################
### LINE ITEM DETAIL ###
########################

#TODO: make the line item prices reflect discount optionally.
# slice up the line items 37 to a page:
line_item_sections = {"srv" => "Services", "sw" => "Software", "hw" => "Hardware"}
line_item_sections.each do |section,section_name|
  if @contract.send("#{section}_line_items").size > 0
    pdf.start_new_page
    #puts "starting new page #{@page_num}"
    set_page :description => "Line Item Detail - #{section_name}", :subheader => @contract.send("#{section}_support_level_id")

    #Header for Detail section
    pdf.header pdf.margin_box.top_left, :height => 150, :width => @full_wide do
      pdf.bounding_box [pdf.bounds.left + 10 ,pdf.bounds.top], :width => half_wide - 10 do
        pdf.image("public/images/SODI-LOGO-TAG-padded.png", :position => :left, :scale => 0.22)
      end
      pdf.bounding_box [pdf.bounds.left + half_wide,pdf.bounds.top - 20], :width => half_wide do
        pdf.text "Source Direct Global HQ\n4555 Excel Parkway, Suite 500\nAddison, TX 75001\n877-503-9800", :size => 8, :align => :right
      end
      pdf.bounding_box([pdf.bounds.left,pdf.bounds.top - 80], :width => 250) do
        pdf.text @page_description, :size => 16, :style => :bold
        pdf.text @page_subheader, :size => 12, :style => :bold
      end
      pdf.bounding_box([pdf.bounds.left + 250, pdf.bounds.top - 80], :width => pdf.bounds.right - 250, :height => 20) do
        pdf.text "Support Agreement ID (SAID): " + @contract.said, :align => :right, :style => :bold, :size => 11
      end
      pdf.bounding_box([pdf.bounds.left + 250, pdf.bounds.top - 100], :width => pdf.bounds.right - 250) do
        pdf.text "SourceDirect Reference Number: " + @contract.sdc_ref, :align => :right, :style => :bold, :size => 11
      end
      pdf.bounding_box([pdf.bounds.left,pdf.bounds.top - 120], :width => @full_wide) do
        pdf.font("Helvetica-Bold")
        pdf.table [["Part Num", "Notes", "Description", "Serial Num.", "Beg Date", "End Date", "Qty", "Monthly List Price", "Ext. Price"]], {:border_style => :grid, :row_colors => ["F2F2F2"], :font_size => 8, :border_width => 1, :row_height => 31, :column_widths => line_detail_widths}
        pdf.fill_color "000000"
        pdf.font("Helvetica")
      end
    end

    @contract.send("#{section}_line_items").each_slice(37) do |line_item_group|
      #pdf.start_new_page
      pdf.bounding_box [pdf.bounds.left,pdf.bounds.top], :height => 152, :width => @full_wide do
      end
      line_item_group.each do |line_item|
        list_price = line_item.list_price.to_f > 0 ? number_to_currency(line_item.list_price) : ""
        ext_price = line_item.list_price.to_f > 0 ? number_to_currency(line_item.ext_list_price) : ""
        islabel = line_item.product_num.upcase == "LABEL" ? true : false
        description = line_item.description
        product_num = line_item.product_num.to_s unless islabel == true
        begins = line_item.begins unless islabel == true
        ends = line_item.ends unless islabel == true
        qty = line_item.qty unless islabel == true
        if islabel 
          pdf.font("Helvetica-Bold")
        end
        pdf.table [[product_num, line_item.note, description, line_item.serial_num, begins, ends, qty, list_price, ext_price]], {:row_colors => islabel ? ["F2F2F2"] : ["FFFFFF"], :horizontal_padding => 0, :vertical_padding => 0, :font_size => 8, :border_width => 0, :row_height => 5, :column_widths => line_detail_widths, :align => { 2 => islabel ? :center : :left, 6 => :center, 7 => :right, 8 => :right}}
        pdf.font("Helvetica")
      end
      if line_item_group.size == 37
        pdf.start_new_page
        set_page :description => "Line Item Detail - #{section_name}", :subheader => @contract.send("#{section}_support_level_id")
      else
        #TODO: calculate the annual list price based on months covered, etc.
        pdf.font("Helvetica-Bold")
        pdf.move_down 3
        pdf.table [["", "", "Total #{section_name} Support - Monthly List Price", "", "", "", "", "", number_to_currency(@contract.send("#{section}_line_items").inject(0) {|sum, n| sum + n.ext_list_price})]], {:horizontal_padding => 0, :vertical_padding => 0, :font_size => 8, :border_width => 0, :row_height => 5, :column_widths => line_detail_widths, :align => {8 => :right}}
        pdf.table [["", "", "Total #{section_name} Support - Annual List Price", "", "", "", "", "", number_to_currency(@contract.send("#{section}_list_price"))]], {:horizontal_padding => 0, :vertical_padding => 0, :font_size => 8, :border_width => 0, :row_height => 5, :column_widths => line_detail_widths, :align => {8 => :right}}
        pdf.font("Helvetica")
        pdf.move_down 3
        pdf.table [["End of #{section_name} Section"]], :vertical_padding => 0, :align => :center, :row_colors => ["F2F2F2"], :font_size => 8, :border_width => 0, :width => @full_wide
      end
    end
  end
end

