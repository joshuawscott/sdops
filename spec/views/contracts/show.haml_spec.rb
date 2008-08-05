require File.dirname(__FILE__) + '/../../spec_helper'

describe "/contracts/show.html.haml" do
  include ContractsHelper
  
  before do

    @user = mock_model(User, :full_name => 'Troy Nini')
    #@user.stub!(:id).and_return("1")
    @user.stub!(:first_name).and_return("MyFirst")
    @user.stub!(:last_name).and_return("MyLast")
    @user.stub!(:office).and_return("MyString")
    assigns[:user] = @user
    User.should_receive(:find).and_return(@user)

    @contract = mock_model(Contract)
    @contract.stub!(:sdc_ref).and_return("MyString")
    @contract.stub!(:description).and_return("MyString")
    @contract.stub!(:sales_rep_id).and_return("1")
    @contract.stub!(:sales_office).and_return("1")
    @contract.stub!(:account_id).and_return("MyString")
    @contract.stub!(:account_name).and_return("MyString")
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
    @contract.stub!(:discount_pref_hw).and_return(1.5)
    @contract.stub!(:discount_pref_sw).and_return(1.5)
    @contract.stub!(:discount_prepay).and_return(1.5)
    @contract.stub!(:discount_multiyear).and_return(1.5)
    @contract.stub!(:discount_ce_day).and_return(1.5)
    @contract.stub!(:discount_sa_day).and_return(1.5)
    @contract.stub!(:support_office).and_return("MyString")
    @contract.stub!(:replacement_sdc_ref).and_return("MyString")
    assigns[:contract] = @contract
    
    @line_item = mock_model(LineItem)
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
    assigns[:line_items] = [@line_item]

    @dropdown = mock_model(Dropdown)
    @dropdown.stub!(:dd_name).and_return("support_type")
    @dropdown.stub!(:label).and_return("24x7")
    assigns[:drop_down] = @dropdown
    Dropdown.should_receive(:find).exactly(5).times.and_return(@dropdown)

  end

  it "should render attributes in <p>" do
    render "contracts/show.html.haml"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/als/)
    response.should have_text(/MyString/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/1\.5/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
  end
end

