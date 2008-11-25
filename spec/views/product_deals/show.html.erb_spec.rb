require File.dirname(__FILE__) + '/../../spec_helper'

describe "/product_deals/show.html.erb" do
  include ProductDealsHelper
  
  before(:each) do
    @product_deal = mock_model(ProductDeal)
    @product_deal.stub!(:job_number).and_return("MyString")
    @product_deal.stub!(:opportunity_id).and_return("1")
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

  it "should render attributes in <p>" do
    render "/product_deals/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
  end
end

