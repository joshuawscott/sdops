require File.dirname(__FILE__) + '/../spec_helper'

describe ProductDeal do
  before(:each) do
    @product_deal = ProductDeal.new
  end

  it "should be valid" do
    @product_deal.should be_valid
  end
end
