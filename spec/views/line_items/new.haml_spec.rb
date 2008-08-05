require File.dirname(__FILE__) + '/../../spec_helper'

describe "contract/line_items/new.html.haml" do
  include LineItemsHelper
  
  before do
    @contract = mock_model(Contract)
    @contract.stub!(:id).and_return("1")
    @contract.stub!(:sdc_ref).and_return("MyString")
    @contract.stub!(:description).and_return("MyString")
    @contract.stub!(:sales_rep_id).and_return("1")
    @contract.stub!(:sales_office).and_return("1")
    @contract.stub!(:account_id).and_return("MyString")
    @contract.stub!(:cust_po_num).and_return("MyString")
    @contract.stub!(:payment_terms).and_return("MyString")
    @contract.stub!(:platform).and_return(false)
    @contract.stub!(:revenue).and_return("MyString")
    @contract.stub!(:annual_hw_rev).and_return("1.5")
    @contract.stub!(:annual_sw_rev).and_return("1.5")
    @contract.stub!(:annual_ce_rev).and_return("1.5")
    @contract.stub!(:annual_sa_rev).and_return("1.5")
    @contract.stub!(:annual_dr_rev).and_return("1.5")
    @contract.stub!(:start_date).and_return(Date.today)
    @contract.stub!(:end_date).and_return(Date.today)
    @contract.stub!(:multiyr_end).and_return(Date.today)
    @contract.stub!(:expired).and_return("MyString")
    @contract.stub!(:hw_support_level_id).and_return("1")
    @contract.stub!(:sw_support_level_id).and_return("1")
    @contract.stub!(:updates).and_return("MyString")
    @contract.stub!(:ce_days).and_return("1")
    @contract.stub!(:sa_days).and_return("1")
    @contract.stub!(:discount_pref_hw).and_return("1.5")
    @contract.stub!(:discount_pref_sw).and_return("1.5")
    @contract.stub!(:discount_prepay).and_return("1.5")
    @contract.stub!(:discount_multiyear).and_return("1.5")
    @contract.stub!(:discount_ce_day).and_return("1.5")
    @contract.stub!(:discount_sa_day).and_return("1.5")
    @contract.stub!(:support_office).and_return("MyString")
    @contract.stub!(:replacement_sdc_ref).and_return("MyString")
    assigns[:contract] = @contract
  
  @line_item = mock_model(LineItem)
    @line_item.stub!(:new_record?).and_return(true)
    @line_item.stub!(:contract_id).and_return("1")
    @line_item.stub!(:support_type).and_return("MyString")
    @line_item.stub!(:product_num).and_return("MyString")
    @line_item.stub!(:serial_num).and_return("MyString")
    @line_item.stub!(:description).and_return("MyString")
    @line_item.stub!(:begins).and_return(Date.today)
    @line_item.stub!(:ends).and_return(Date.today)
    @line_item.stub!(:qty).and_return("1")
    @line_item.stub!(:list_price).and_return("1")
    assigns[:line_item] = @line_item
  end

  it "should render new form" do
    render "line_items/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", contract_line_items_path(@contract.id)) do
      with_tag("input#line_item_support_type[name=?]", "line_item[support_type]")
      with_tag("input#line_item_product_num[name=?]", "line_item[product_num]")
      with_tag("input#line_item_serial_num[name=?]", "line_item[serial_num]")
      with_tag("input#line_item_description[name=?]", "line_item[description]")
      with_tag("input#line_item_qty[name=?]", "line_item[qty]")
      with_tag("input#line_item_list_price[name=?]", "line_item[list_price]")
    end
  end
end


