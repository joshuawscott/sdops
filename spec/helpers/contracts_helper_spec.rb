require 'spec_helper'

describe ContractsHelper do
  describe "discount_to_percentage" do
    it "converts nil" do
      helper.discount_to_percentage(nil).should == "0%"
    end
    it "converts 0" do
      helper.discount_to_percentage(0).should == "0%"
    end
    it "converts single integers" do
      helper.discount_to_percentage(1).should == "100%"
      helper.discount_to_percentage(50).should == "5000%"
    end
    it "converts floats" do
      helper.discount_to_percentage(0.0001).should == "0.01%"
      helper.discount_to_percentage(0.001).should == "0.1%"
      helper.discount_to_percentage(0.01).should == "1%"
      helper.discount_to_percentage(0.1).should == "10%"
    end
    it "rounds down correctly" do
      helper.discount_to_percentage(0.00001).should == "0%"
      helper.discount_to_percentage(0.494444444).should == "49.44%"
    end
    it "rounds up correctly" do
      helper.discount_to_percentage(0.49455).should == "49.46%"
      helper.discount_to_percentage(0.00005).should == "0.01%"
    end
  end
end
