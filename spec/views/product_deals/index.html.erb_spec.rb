require File.dirname(__FILE__) + '/../../spec_helper'

describe "/product_deals/index.html.erb" do
  include ProductDealsHelper
  
  before(:each) do
    product_deal_98 = mock_model(ProductDeal)
    product_deal_98.should_receive(:job_number).and_return("MyString")
    product_deal_98.should_receive(:opportunity_id).and_return("1")
    product_deal_98.should_receive(:account_id).and_return("MyString")
    product_deal_98.should_receive(:account_name).and_return("MyString")
    product_deal_98.should_receive(:invoice_number).and_return("MyString")
    product_deal_98.should_receive(:revenue).and_return("1")
    product_deal_98.should_receive(:cogs).and_return("1")
    product_deal_98.should_receive(:freight).and_return("1")
    product_deal_98.should_receive(:status).and_return("MyString")
    product_deal_98.should_receive(:modified_by).and_return("MyString")
    product_deal_98.should_receive(:created_at).and_return(Time.now)
    product_deal_98.should_receive(:updated_at).and_return(Time.now)
    product_deal_99 = mock_model(ProductDeal)
    product_deal_99.should_receive(:job_number).and_return("MyString")
    product_deal_99.should_receive(:opportunity_id).and_return("1")
    product_deal_99.should_receive(:account_id).and_return("MyString")
    product_deal_99.should_receive(:account_name).and_return("MyString")
    product_deal_99.should_receive(:invoice_number).and_return("MyString")
    product_deal_99.should_receive(:revenue).and_return("1")
    product_deal_99.should_receive(:cogs).and_return("1")
    product_deal_99.should_receive(:freight).and_return("1")
    product_deal_99.should_receive(:status).and_return("MyString")
    product_deal_99.should_receive(:modified_by).and_return("MyString")
    product_deal_99.should_receive(:created_at).and_return(Time.now)
    product_deal_99.should_receive(:updated_at).and_return(Time.now)

    assigns[:product_deals] = [product_deal_98, product_deal_99]
  end

  it "should render list of product_deals" do
    render "/product_deals/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

