require File.dirname(__FILE__) + '/../../spec_helper'

describe "/product_deals/new.html.erb" do
  include ProductDealsHelper
  
  before(:each) do
    @product_deal = mock_model(ProductDeal)
    @product_deal.stub!(:new_record?).and_return(true)
    @product_deal.stub!(:job_number).and_return("MyString")
    @product_deal.stub!(:sugar_opp_id).and_return("1")
    @product_deal.stub!(:account_id).and_return("MyString")
    @product_deal.stub!(:account_name).and_return("MyString")
    @product_deal.stub!(:invoice_number).and_return("MyString")
    @product_deal.stub!(:revenue).and_return("1")
    @product_deal.stub!(:cogs).and_return("1")
    @product_deal.stub!(:freight).and_return("1")
    @product_deal.stub!(:status).and_return("MyString")
    @product_deal.stub!(:modified_by).and_return("MyString")
    @product_deal.stub!(:created_at).and_return(Time.now)
    @product_deal.stub!(:updated_at).and_return(Time.now)
    assigns[:product_deal] = @product_deal
  end

  it "should render new form" do
    render "/product_deals/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", product_deals_path) do
      with_tag("input#product_deal_job_number[name=?]", "product_deal[job_number]")
      with_tag("input#product_deal_account_name[name=?]", "product_deal[account_name]")
      with_tag("input#product_deal_invoice_number[name=?]", "product_deal[invoice_number]")
      with_tag("input#product_deal_revenue[name=?]", "product_deal[revenue]")
      with_tag("input#product_deal_cogs[name=?]", "product_deal[cogs]")
      with_tag("input#product_deal_freight[name=?]", "product_deal[freight]")
      with_tag("input#product_deal_status[name=?]", "product_deal[status]")
      with_tag("input#product_deal_modified_by[name=?]", "product_deal[modified_by]")
    end
  end
end


