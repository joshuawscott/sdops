require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe SwSupportPrice do

  before(:each) do
    SwSupportPrice.count.should == 0
    @initial_item = Factory(:sw_support_price, :phone_price => 200.00, :update_price => 100.0, :modified_at => Date.parse('1970-01-01'), :confirm_date => Date.parse('1970-01-01'))
    @first_item   = Factory(:sw_support_price, :phone_price => 200.00, :update_price => 200.0, :modified_at => Date.parse('2009-01-01'), :confirm_date => Date.parse('2008-01-01'))
    @second_item  = Factory(:sw_support_price, :phone_price => 300.00, :update_price => 200.0, :modified_at => Date.parse('2009-06-01'), :confirm_date => Date.parse('2008-06-01'))
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

    it "should change modified at to today when null" do
      price = Factory.build(:sw_support_price, :modified_at => nil)
      price.save
      price.modified_at.should == Date.today
    end

    it "should allow modified_at to be set to something else on save" do
      price = Factory.build(:sw_support_price, :modified_at => nil)
      price.save
      price.modified_at = Date.parse('2001-01-01')
      price.save
      price.modified_at.should == Date.parse('2001-01-01')
    end

  end

  describe "Prevent price regression" do
    it "should not save the price when another exists with a later confirmation date" do
      price_count = SwSupportPrice.count
      old_price = Factory(:sw_support_price, :confirm_date => Date.parse('2010-01-01'))
      SwSupportPrice.count.should == price_count + 1
      price = Factory.build(:sw_support_price, :confirm_date => Date.parse('2009-01-01'))
      price.save
      SwSupportPrice.count.should_not == price_count + 2
    end

    it "should not save the price when another exists with the same modified_at date" do
      price_count = SwSupportPrice.count
      old_price = Factory(:sw_support_price, :modified_at => Date.parse('2011-01-01'))
      SwSupportPrice.count.should == price_count + 1
      price = Factory.build(:sw_support_price, :modified_at => Date.parse('2011-01-01'))
      price.save
      SwSupportPrice.count.should_not == price_count + 2
    end

    it "should still save an updated record" do
      #regression test for a bug that prevented a record from updating because the date
      #already exists.
      price = SwSupportPrice.find(@initial_item.id)
      price.update_attributes(:description => "new description")
      price = SwSupportPrice.find(@initial_item.id)
      price.description.should == "new description"
    end

  end

end
