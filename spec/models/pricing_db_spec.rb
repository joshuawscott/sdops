require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe PricingDb do
  describe "find_sun_pn" do
    context "successful find" do
      before(:each) { @price = PricingDb.find_sun_pn('T20Z108B-32GA2G') }

      it("should find a sun part number") { @price.mkt_part_number.should == "T20Z108B-32GA2G" }
      it("should set the description accessor") { @price.description.should == "Sun Fire T2000 - SFT2000 8core 1.2GHz 32GB 2x73" }
      it("should set the list_price") { @price.list_price.should == 148.50 }
      it("should find a sun price") { @price.oow_price.should == 247.50 }
    end
    context "unsuccessful find" do
      before(:each) { @price = PricingDb.find_sun_pn('completelyboguspart') }

      it("should return a 0 list price when no product is found") { @price.list_price.should == 0.0 }
      it("should return a blank description when no product is found") { @price.description.should == "" }
    end
  end

  describe "find_hp_pn" do
    %w(hw sw).each do |type|
      context "successful #{type} find" do
        before(:each) {@price = PricingDb.find_hp_pn("AB537A", type)}

        it("should find an HP part number for #{type}") { @price.product_number.should == 'AB537A' }
        it("should set the description accessor for #{type}") { @price.description.should == 'HP rp7420/rp8420 1.1 GHz PA8900 Dual CPU' }
        it("should set the list price accessor for #{type}") { @price.list_price.should == (type == 'hw' ? 615 : BigDecimal("91.75")) }
      end
      context "unsuccessful #{type} find" do
        before(:each) {@price = PricingDb.find_hp_pn("boguspartnumber", type)}
        it("should return a 0 list price when no product is found - #{type}") { @price.list_price.should == 0 }
        it("should return a blank description when no product is found - #{type}") {@price.description.should == ''}
      end
    end
  end
end
