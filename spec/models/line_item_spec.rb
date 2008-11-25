require File.dirname(__FILE__) + '/../spec_helper'
#TODO:  Add specs to test deletion of line items when contract deleted

describe LineItem do
  before(:each) do
    @line_item = LineItem.new
  end

  it "should be valid" do
    @line_item.should be_valid
  end
end
