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
      @subcontractor = Factory :subcontractor
      @subcontract = Factory :subcontract
      @line_item = Factory :line_item, :subcontract_id => @subcontract.id
      @subcontract.line_items.count.should == 1
      @line_item.remove_from @subcontract
      @subcontract.line_items.count.should == 0
    end

  end
  describe "LineItem.effective_months" do
    def d date
      Date.parse date
    end
    before(:all) do
      @line_item12a  = Factory(:line_item, :begins => d('2009-01-01'), :ends => d('2009-12-31'))
      @line_item12b  = Factory(:line_item, :begins => d('2008-02-01'), :ends => d('2009-01-31'))
      @line_item5a   = Factory(:line_item, :begins => d('2009-01-01'), :ends => d('2009-05-31'))
      @line_item5b   = Factory(:line_item, :begins => d('2009-02-15'), :ends => d('2009-07-14'))
      @line_item17   = Factory(:line_item, :begins => d('2008-01-15'), :ends => d('2009-06-14'))
      @line_item4o32 = Factory(:line_item, :begins => d('2008-01-01'), :ends => d('2008-05-10'))
      @line_item0    = Factory(:line_item, :begins => d('2009-01-01'), :ends => d('2008-06-01'))
      @contract = Factory(:contract, :start_date => d('2009-01-01'), :end_date => d('2009-12-31'))
      @contract.line_items << @line_item1 = Factory(:line_item, :begins => d('2008-02-01'), :ends => d('2009-01-31'))
      @contract.line_items << @line_item11 = Factory(:line_item, :begins => d('2009-02-01'), :ends => d('2010-01-31'))
      @contract.line_items << @line_item00 = Factory(:line_item, :begins => d('2008-01-01'), :ends => d('2008-12-31'))
      @contract.line_items << @line_item000 = Factory(:line_item, :begins => d('2010-01-01'), :ends => d('2010-12-31'))
    end

    it "returns 12 for a jan 1 - dec 31 line_item" do
      @line_item12a.effective_months.should == 12
    end
    it "returns 12 for a feb 1 - jan 31 line_item" do
      @line_item12b.effective_months.should == 12
    end
    it "returns 5 for a jan 1 to may 31 line_item" do
      @line_item5a.effective_months.should == 5
    end
    it "returns 5 for a feb 15 to july 14 line_item" do
      @line_item5b.effective_months.should == 5
    end
    it "returns 17 fora jan 15 08 to june 14 09 line_item" do
      @line_item17.effective_months.should == 17
    end
    it "returns 4.322580645161290... for a Jan 1 to May 10 line_item" do
      @line_item4o32.effective_months.should == (4.0 + (10.0 / 31.0))
    end
    it "returns 0 when the start date is after the end date" do
      @line_item0.effective_months.should == 0.0
    end
    it "returns 11 months when only 11 months overlap with the parent contract" do
      @line_item11.effective_months.should == 11.0
    end
    it "returns 0 when the ends is before the parent contract start date" do
      @line_item000.effective_months.should == 0.0
    end
    it "returns 0 when the begins is after the parent contract end date" do
      @line_item000.effective_months.should == 0.0
    end
    

    after(:all) do
      LineItem.delete_all
      Contract.delete_all
    end
  end

end
