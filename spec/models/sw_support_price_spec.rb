require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe SwSupportPrice do

  before(:each) do
    item_hash = {:part_number => "A6144A", :description => "L3000"}
    @initial_item = SwSupportPrice.create!(item_hash.merge(:phone_price => 150.0, :update_price => 150.0, :modified_at => '0000-00-00'))
    @first_item = SwSupportPrice.create!(item_hash.merge(:phone_price => 250.0, :update_price => 150.0, :modified_at => '2009-01-01'))
    @second_item = SwSupportPrice.create!(item_hash.merge(:phone_price => 300.0, :update_price => 200.0, :modified_at => '2009-06-01'))
  end

  describe "quote" do

    it "should return 300 when the quote date is before 2009" do
      item = SwSupportPrice.getprice("A6144A", Date.parse("2008-01-01"))
      item.list_price.should == BigDecimal.new("300.0")
    end

    it "should return 300 when the quote date is 12/31/2008" do
      item = SwSupportPrice.getprice("A6144A", Date.parse("2008-12-31"))
      item.list_price.should == BigDecimal.new("300.0")
    end

    it "should return 400 when the quote date is 1/1/2009" do
      item = SwSupportPrice.getprice("A6144A", Date.parse("2009-01-01"))
      item.list_price.should == BigDecimal.new("400.0")
    end

    it "should return 400 when the quote date is 1/2/2009" do
      item = SwSupportPrice.getprice("A6144A", Date.parse("2009-01-02"))
      item.list_price.should == BigDecimal.new("400.0")
    end

    it "should return 500 when the quote date is 1/1/2010" do
      item = SwSupportPrice.getprice("A6144A", Date.parse("2010-01-01"))
      item.list_price.should == BigDecimal.new("500.0")
    end
  end

  describe "validations" do

    it "should be valid" do
      price = Factory.build(:sw_support_price)
      price.should be_valid
    end

    it "should not be valid without part_number" do
      price = Factory.build(:sw_support_price, :part_number => nil)
      price.should_not be_valid
    end

    it "should change modified at to 1970-01-01 when null" do
      price = Factory.build(:sw_support_price, :modified_at => nil)
      price.save
      price.modified_at.should == Date.parse('1970-01-01')
    end
  end

  describe "Prevent price regression" do
    it "should not save the price when another exists with a later confirmation date" do
      price_count = HwSupportPrice.count
      old_price = Factory(:hw_support_price, :confirm_date => Date.parse('2010-01-01'))
      HwSupportPrice.count.should == price_count + 1
      price = Factory.build(:hw_support_price, :confirm_date => Date.parse('2009-01-01'))
      price.save
      HwSupportPrice.count.should_not == price_count + 2
    end

    it "should not save the price when another exists with the same modified_at date" do
      price_count = HwSupportPrice.count
      old_price = Factory(:hw_support_price, :modified_at => Date.parse('2011-01-01'))
      HwSupportPrice.count.should == price_count + 1
      price = Factory.build(:hw_support_price, :modified_at => Date.parse('2011-01-01'))
      price.save
      HwSupportPrice.count.should_not == price_count + 2
    end
  end

end
