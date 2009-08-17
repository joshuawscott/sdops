require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe LineItem do

  describe "LineItem.locations"

  describe "LineItem.hw_revenue_by_location"

  describe "LineItem.update_all_current_prices"

  describe "ext_list_price"

  describe "ext_current_list_price"

  describe "ext_effective_price"

  describe "return_current_info"

  describe "LineItem.support_types"

  describe "#remove_from" do
    it "should remove the line item from subcontract" do
      @subcontract = Factory :subcontract
      @line_item = Factory :line_item, :subcontract_id => @subcontract.id
      @subcontract.line_items.count.should == 1
      @line_item.remove_from @subcontract
      @subcontract.line_items.count.should == 0
    end

  end

end
