require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
#   id            integer
#   part_number   string
#   description   string
#   list_price    decimal
#   modified_by   string
#   modified_at   date
#   confirm_date  date
#   notes         text

describe SupportPriceHw do

  before(:each) do
    item_hash = {:part_number => "A6144A", :description => "L3000"}
    @initial_item = SupportPriceHw.create!(item_hash.merge(:list_price => 300.0, :modified_at => '0000-00-00'))
    @first_item = SupportPriceHw.create!(item_hash.merge(:list_price => 400.0, :modified_at => '2009-01-01'))
    @second_item = SupportPriceHw.create!(item_hash.merge(:list_price => 500.0, :modified_at => '2009-06-01'))
  end

  describe "quote" do

    context "when the quote date is before 2009" do
      it "should return 300" do
        item = SupportPriceHw.getprice("A6144A", Date.parse("2008-01-01"))
        item.list_price.should == BigDecimal.new("300.0")
      end
    end

    context "when the quote date is 12/31/2008" do
      it "should return 300" do
        item = SupportPriceHw.getprice("A6144A", Date.parse("2008-12-31"))
        item.list_price.should == BigDecimal.new("300.0")
      end
    end

    context "when the quote date is 1/1/2009" do
      it "should return 400" do
        item = SupportPriceHw.getprice("A6144A", Date.parse("2009-01-01"))
        item.list_price.should == BigDecimal.new("400.0")
      end
    end

    context "when the quote date is 2009-01-02" do
      it "should return 400" do
        item = SupportPriceHw.getprice("A6144A", Date.parse("2009-01-02"))
        item.list_price.should == BigDecimal.new("400.0")
      end
    end

    context "when the quote date is 2010-01-01" do
      it "should return 500" do
        item = SupportPriceHw.getprice("A6144A", Date.parse("2010-01-01"))
        item.list_price.should == BigDecimal.new("500.0")
      end
    end

  end

end
