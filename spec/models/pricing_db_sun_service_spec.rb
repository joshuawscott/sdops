require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe PricingDbSunService do
  context "good server part number" do
    before(:each) do
      @price = PricingDbSunService.find_pn("A28-AA")
    end
    it "should return a price" do
      @price.list_price.class.should == BigDecimal
      @price.list_price.should_not == 0.0
    end

    it "should return a PricingDbSunService object" do
      @price.class.should == PricingDbSunService
    end
    it "should set list_price to oow_price x 0.6" do
      @price.list_price.should == @price.oow_price * BigDecimal("0.6")
    end

    it "should have a description" do
      @price.description.class.should == String
    end
  end
  context "good software part number" do
    before(:each) do
      @price = PricingDbSunService.find_pn("BNVNS-999-141E")
    end
    it "should return a price" do
      @price.list_price.class.should == BigDecimal
      @price.list_price.should_not == 0.0
    end

    it "should return a PricingDbSunService object" do
      @price.class.should == PricingDbSunService
    end
    it "should set list_price to oow_price" do
      @price.list_price.should == @price.oow_price
    end

    it "should have a description" do
      @price.description.class.should == String
    end
  end
  context "good storage part number" do
    before(:each) do
      @price = PricingDbSunService.find_pn("XTA3320R00A0T365")
    end
    it "should return a price" do
      @price.list_price.class.should == BigDecimal
      @price.list_price.should_not == 0.0
    end

    it "should return a PricingDbSunService object" do
      @price.class.should == PricingDbSunService
    end
    it "should set list_price to oow_price" do
      @price.list_price.should == @price.oow_price
    end

    it "should have a description" do
      @price.description.class.should == String
    end
  end

  it "should return a new object for a non-good part number" do
    PricingDbSunService.find_pn('BOGUSPARTNUMBER').class.should == PricingDbSunService
    PricingDbSunService.find_pn('BOGUSPARTNUMBER').new_record?.should == true
  end
end
