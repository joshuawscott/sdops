require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe LineItem do

  describe "LineItem.locations"

  describe ".hw_revenue_by_location" do

    before(:all) do
      line_item1 = Factory(:line_item, :qty => 1, :support_type => "SW", :location => "Dallas",    :begins => '2010-01-01', :ends => '2010-12-31', :list_price => '1.0', :effective_price => '1.0')
      line_item2 = Factory(:line_item, :qty => 1, :support_type => "SRV", :location => "Dallas",    :begins => '2010-01-01', :ends => '2010-12-31', :list_price => '1.0', :effective_price => '1.0')
      line_item3 = Factory(:line_item, :qty => 1, :support_type => "HW", :location => "Charlotte", :begins => '2010-03-15', :ends => '2010-12-31', :list_price => '1.0', :effective_price => '1.0')
      line_item4 = Factory(:line_item, :qty => 1, :support_type => "HW", :location => "Charlotte", :begins => '2010-01-01', :ends => '2010-12-31', :list_price => '1.0', :effective_price => '1.0')
      line_item5 = Factory(:line_item, :qty => 1, :support_type => "HW", :location => "Dallas",    :begins => '2010-01-01', :ends => '2010-12-31', :list_price => '1.0', :effective_price => '1.0')
      line_item6 = Factory(:line_item, :qty => 1, :support_type => "HW", :location => "Charlotte", :begins => '2009-01-01', :ends => '2009-12-31', :list_price => '1.0', :effective_price => '1.0')
      line_item7 = Factory(:line_item, :qty => 1, :support_type => "HW", :location => "Charlotte", :begins => '2011-01-01', :ends => '2011-12-31', :list_price => '1.0', :effective_price => '1.0')
      line_item8 = Factory(:line_item, :qty => 1, :support_type => "HW", :location => "Dallas",    :begins => '2009-01-01', :ends => '2009-12-31', :list_price => '1.0', :effective_price => '1.0')
      line_item9 = Factory(:line_item, :qty => 1, :support_type => "HW", :location => "Dallas",    :begins => '2011-01-01', :ends => '2011-12-31', :list_price => '1.0', :effective_price => '1.0')
      contract = Factory(:contract, :expired => false, :account_name => 'foo', :discount_pref_hw => 0.0, :discount_pref_sw => 0.0, :discount_pref_srv => 0.0, :discount_prepay => 0.0, :discount_multiyear => 0.0)
      contract.line_items = [line_item1, line_item2, line_item3, line_item4, line_item5, line_item6, line_item7, line_item8, line_item9]
      @locations = LineItem.hw_revenue_by_location(Date.parse('2010-06-01'))
    end

    it "should sort Charlotte first" do
      @locations[0][:location].should == "Charlotte"
    end

    it "should sort Dallas last" do
      @locations[1][:location].should == "Dallas"
    end

    it "should calculate the price for Charlotte" do
      @locations[0][:revenue].should == 24.0
    end

    it "should calculate the price for Dallas" do
      @locations[1][:revenue].should == 12.0
    end

    after(:all) do
      Contract.delete_all
      LineItem.delete_all
    end
  end

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

    it "verifies that the line items belong to the contract" do
      @line_item1.support_deal.should == @contract
      @line_item11.support_deal.should == @contract
      @line_item00.support_deal.should == @contract
      @line_item000.support_deal.should == @contract
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
    it "returns 1 month when only 1 month overlaps with the parent contract" do
      @line_item1.effective_months.should == 1.0
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

  describe "LineItem.spares_assessment" do
    before(:all) do
      @contract = Factory(:contract, :start_date => d('2009-01-01'), :end_date => d('2009-12-31') )
      a = Factory(:line_item, :qty => 1, :location => 'Dallas', :support_provider => 'Sourcedirect', :product_num => 'A5001', :description => 'Description A5001', :begins => d('2009-01-01'), :ends => d('2009-12-31'))
      b = Factory(:line_item, :qty => 1, :location => 'Dallas', :support_provider => 'Sourcedirect', :product_num => 'A5001', :description => 'Description A5001', :begins => d('2009-01-01'), :ends => d('2009-12-31'))
      c = Factory(:line_item, :qty => 1, :location => 'Dallas', :support_provider => 'Sourcedirect', :product_num => 'A5001', :description => 'Description A5001', :begins => d('2009-01-01'), :ends => d('2009-12-31'))
      d = Factory(:line_item, :qty => 1, :location => 'Dallas', :support_provider => 'Sourcedirect', :product_num => 'A5002', :description => 'Description A5002', :begins => d('2009-01-01'), :ends => d('2009-12-31'))
      e = Factory(:line_item, :qty => 1, :location => 'Dallas', :support_provider => 'Sourcedirect', :product_num => 'A5005', :description => 'Description A5005', :begins => d('2009-01-01'), :ends => d('2009-12-31'))
      @contract.line_items = [a,b,c,d,e]
      #Factory(:inventory_item, :id => 'a', :item_code => 'A5001')
      #Factory(:inventory_item, :id => 'b', :item_code => 'A5001')
      #Factory(:inventory_item, :id => 'c', :item_code => 'A5002')
      #Factory(:inventory_item, :id => 'd', :item_code => 'A5003')
      #Factory(:inventory_item, :id => 'e', :item_code => 'A5003')
      @line_items = LineItem.sparesreq("Dallas")
    end
    it "finds the line items and corresponding inventory items" do
      FishbowlQoh.should_receive(:find).and_return([0,1]) #mocking up an array of 2 items returned
      @line_items[0].product_num.should == 'A5001'
      @line_items[0].base_product.should == 'A5001'
      @line_items[0].description.should == "Description A5001"
      @line_items[0].qty_instock.should == 2
      @line_items[0].count.to_i.should == 3
    end
    after(:all) do
      Contract.delete_all
      LineItem.delete_all
      InventoryItem.delete_all
    end
  end

  describe "LineItem#list_price_for_month" do
    before(:all) do
      contract = Factory(:contract, :start_date => d('2009-01-01'), :end_date => d('2009-12-31') )
      @line_item = Factory(:line_item, :begins => d('2009-01-21'), :ends => d('2009-12-15'), :list_price => 1.0, :qty => 1 )
      contract.line_items << @line_item
    end
    it "prices a full month correctly" do
      @line_item.list_price_for_month(:month => 2, :year => 2009).should == 1.0
    end
    it "prices a beginning partial month correctly" do
      @line_item.list_price_for_month(:month => 1, :year => 2009).should == (11.0 / 31.0)
    end
    it "prices a ending partial month correctly" do
      @line_item.list_price_for_month(:month => 12, :year => 2009).should == (15.0 / 31.0)
    end
    it "prices a month after the contract correctly" do
      @line_item.list_price_for_month(:month =>1, :year => 2010).should == (0.0)
    end
    it "prices a month before the contract correctly" do
      @line_item.list_price_for_month(:month =>12, :year => 2008).should == (0.0)
    end
    it "prices a partial start and stop correctly" do
      @line_item.ends = d('2009-01-22')
      @line_item.list_price_for_month(:month => 1, :year => 2009).should == (2.0 / 31.0)
    end
    after(:all) do
      LineItem.delete_all
      Contract.delete_all
    end
  end

  describe "#calculated_list_price" do
    before(:all) do
      Factory(:contract, :start_date => '2010-01-01', :end_date => '2010-12-31')
    end
  end
  describe "LineItem.for_customer" do
    before(:all) do
      contract_a = Factory(:contract, :account_id => 'a', :start_date => '2010-01-01', :end_date => '2010-12-31')
      contract_b = Factory(:contract, :account_id => 'b', :start_date => '2010-01-01', :end_date => '2010-12-31')
      @line_item_for_a = Factory(:line_item, :begins => '2010-01-01', :ends => '2010-12-31')
      @line_item_for_b = Factory(:line_item, :begins => '2010-01-01', :ends => '2010-12-31')
      contract_a.line_items = [@line_item_for_a]
      contract_b.line_items = [@line_item_for_b]
    end
    it "should find a" do
      LineItem.for_customer("a").should == [@line_item_for_a]
    end
    it "should not find b" do
      LineItem.for_customer("a").should_not == [@line_item_for_b]
    end
    after :all do
      LineItem.delete_all
      Contract.delete_all
    end
  end
end
