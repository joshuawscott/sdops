require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe SupportPriceSw do

  before(:each) do
    item_hash = {:part_number => "A6144A", :description => "L3000"}
    @initial_item = SupportPriceSw.create!(item_hash.merge(:phone_price => 150.0, :update_price => 150.0, :modified_at => '0000-00-00'))
    @first_item = SupportPriceSw.create!(item_hash.merge(:phone_price => 250.0, :update_price => 150.0, :modified_at => '2009-01-01'))
    @second_item = SupportPriceSw.create!(item_hash.merge(:phone_price => 300.0, :update_price => 200.0, :modified_at => '2009-06-01'))
  end

  describe "quote" do

    context "when the quote date is before 2009" do
      it "should return 300" do
        item = SupportPriceSw.getprice("A6144A", Date.parse("2008-01-01"))
        item.list_price.should == BigDecimal.new("300.0")
      end
    end

    context "when the quote date is 12/31/2008" do
      it "should return 300" do
        item = SupportPriceSw.getprice("A6144A", Date.parse("2008-12-31"))
        item.list_price.should == BigDecimal.new("300.0")
      end
    end

    context "when the quote date is 1/1/2009" do
      it "should return 400" do
        item = SupportPriceSw.getprice("A6144A", Date.parse("2009-01-01"))
        item.list_price.should == BigDecimal.new("400.0")
      end
    end

    context "when the quote date is 1/2/2009" do
      it "should return 400" do
        item = SupportPriceSw.getprice("A6144A", Date.parse("2009-01-02"))
        item.list_price.should == BigDecimal.new("400.0")
      end
    end

    context "when the quote date is 1/1/2010" do
      it "should return 500" do
        item = SupportPriceSw.getprice("A6144A", Date.parse("2010-01-01"))
        item.list_price.should == BigDecimal.new("500.0")
      end
    end

  end

end
