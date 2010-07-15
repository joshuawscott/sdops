require 'spec_helper'

describe CiscoProduct do

  before(:all) do
    @cisco_product = CiscoProduct.new('asdf')
    @cisco_product.stub!(:base_price).and_return 300.00
    @cisco_product.stub!(:full_price).and_return 600.00
    @cisco_product.stub!(:description).and_return "This is a test"
  end

  describe "hw_price" do
    it "should calculate the hw_price" do
      @cisco_product.hw_price.should == 31.25
    end
  end

  describe "sw_price" do
    it "should calculate the sw_price" do
      @cisco_product.sw_price.should == 31.25
    end
  end

end
