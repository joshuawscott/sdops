require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe HwSupportPrice do

  before(:each) do
    HwSupportPrice.count.should == 0
    @initial_item = Factory(:hw_support_price, :list_price => 300.00, :modified_at => Date.parse('1970-01-01'), :confirm_date => Date.parse('1970-01-01'), :manufacturer_line_id => 1)
    @first_item   = Factory(:hw_support_price, :list_price => 400.00, :modified_at => Date.parse('2009-01-01'), :confirm_date => Date.parse('2008-01-01'), :manufacturer_line_id => 1)
    @second_item  = Factory(:hw_support_price, :list_price => 500.00, :modified_at => Date.parse('2009-06-01'), :confirm_date => Date.parse('2008-06-01'), :manufacturer_line_id => 1)
  end

  describe "quote" do

    it "should return 300 when the quote date is before 2009" do
      item = HwSupportPrice.getprice("A6144A", Date.parse("2008-01-01"))
      item.list_price.should == BigDecimal.new("300.0")
    end

    it "should return 300 when the quote date is 12/31/2008" do
      item = HwSupportPrice.getprice("A6144A", Date.parse("2008-12-31"))
      item.list_price.should == BigDecimal.new("300.0")
    end

    it "should return 400 when the quote date is 1/1/2009" do
      item = HwSupportPrice.getprice("A6144A", Date.parse("2009-01-01"))
      item.list_price.should == BigDecimal.new("400.0")
    end

    it "should return 400 when the quote date is 2009-01-02" do
      item = HwSupportPrice.getprice("A6144A", Date.parse("2009-01-02"))
      item.list_price.should == BigDecimal.new("400.0")
    end

    it "should return 500 when the quote date is 2010-01-01" do
      item = HwSupportPrice.getprice("A6144A", Date.parse("2010-01-01"))
      item.list_price.should == BigDecimal.new("500.0")
    end

  end

  describe "validations" do

    it "should be valid" do
      price = Factory.build(:hw_support_price)
      price.should be_valid
    end

    it "should not be valid without part_number" do
      price = Factory.build(:hw_support_price, :part_number => nil)
      price.should_not be_valid
    end

    it "should change modified at to today when null" do
      price = Factory.build(:hw_support_price, :modified_at => nil)
      price.save
      price.modified_at.should == Date.today
    end

    it "should allow modified_at to be set to something else on save" do
      price = Factory.build(:hw_support_price, :modified_at => nil)
      price.save
      price.modified_at = Date.parse('2001-01-01')
      price.save
      price.modified_at.should == Date.parse('2001-01-01')
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

    it "should still save an updated record" do
      #regression test for a bug that prevented a record from updating because the date
      #already exists.
      price = HwSupportPrice.find(@initial_item.id)
      price.update_attributes(:description => "new description")
      price = HwSupportPrice.find(@initial_item.id)
      price.description.should == "new description"
    end

  end

end
