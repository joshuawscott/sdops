require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe PricingDbHpPrice do
  describe "find_hw_pn" do
    context "good hardware part number" do
      before(:each) do
        @price = PricingDbHpPrice.find_hw_pn('AB537A')
      end

      it "should return a price" do
        @price.list_price.class.should == BigDecimal
        @price.list_price.should_not == BigDecimal("0.0")
      end

      it "should have a description" do
        @price.description.class.should == String
      end

      it "should return a PricingDbHpPrice object" do
        @price.class.should == PricingDbHpPrice
      end
    end
  end

  describe "find_sw_pn" do
    context "good software part number" do
      before(:each) do
        @price = PricingDbHpPrice.find_sw_pn('B9089AC')
      end

      it "should return a price" do
        @price.list_price.class.should == BigDecimal
        @price.list_price.should_not == BigDecimal("0.0")
      end

      it "should have a description" do
        @price.description.class.should == String
      end

      it "should return a PricingDbHpPrice object" do
        @price.class.should == PricingDbHpPrice
      end
    end
  end

  context "bogus hardware part number" do
    before(:each) do
      @price = PricingDbHpPrice.find_hw_pn('BOGUSPRODUCTNUMBER')
    end

    it "should return a new object" do
      @price.new_record?.should == true
    end

  end

  context "bogus software part number" do
    before(:each) do
      @price = PricingDbHpPrice.find_sw_pn('BOGUSPRODUCTNUMBER')
    end

    it "should return a new object" do
      @price.new_record?.should == true
    end

  end

  describe "self.option_price" do
    {'6M1' => 'software option', '407' => 'hardware option', '6CZ' => 'mixed option', 'invalid' => 'invalid option'}.each do |option_number,option_type|
      {'HA104A' => 'hardware', 'HA107A' => 'software'}.each do |product_number, type|
        [1,3,4].each do |year|
          # 45 scenarios to cover every possible query type.
          before(:each) do
            @price = PricingDbHpPrice.option_price(:product_number => product_number, :year => year, :option_number => option_number)
          end
          it "should return a BigDecimal for a #{type} product number, #{option_type}, and #{year} year(s)" do
            @price.class.should == BigDecimal
          end
          if option_type == 'invalid option'
            it "should return 0 for invalid options" do
              @price.should == 0.0
            end
          end
          if option_type == 'software option' && type == 'hardware'
            it "should return 0 when the option is software and the product is hardware" do
              @price.should == 0.0
            end
          end
          if option_type == 'hardware option' && type == 'software'
            it "should return 0 when the option is hardware and the product is software" do
              @price.should == 0.0
            end
          end
        end
      end
    end
  end
end
