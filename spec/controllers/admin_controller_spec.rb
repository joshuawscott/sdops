require File.dirname(__FILE__) + '/../spec_helper'
describe AdminController do
  before(:each) do
    controller.stub!(:login_required)
    controller.stub!(:authorized?)
    @contract = mock_model(Contract)
    @line_item = mock_model(LineItem)
  end

  describe "POST jared.xls" do
    before :each do
      Contract.stub!(:find).and_return([@contract])
      Contract.should_receive(:find).with(:last).and_return(@contract)
    end
    it "finds the contracts between the ids given" do
      Contract.should_receive(:find)
      post :jared, :format => 'xls', :params => {"first_id" => 5, "last_id" => 10}
    end
    it "should assign found contracts to @contracts" do
      post :jared, :format => 'xls', :params => {"first_id" => 5, "last_id" => 10}
      assigns[:contracts].should == [@contract]
    end
  end

  describe "GET check_for_renewals" do
    before :each do
      Contract.stub!(:find).and_return(@contract)
      @contract.should_receive(:line_items).and_return([@line_item])
      @line_item.should_receive(:serial_num).and_return("MOCKSN")
      Contract.should_receive(:serial_search).with("MOCKSN").and_return([@contract])
    end
    it "should assign the contract to @contract" do
      get :check_for_renewals, :params => {"id" => 1}
      assigns[:contract].should == @contract
    end
    it "should assign found contracts to @contracts" do
      get :check_for_renewals, :params => {"id" => 1}
      assigns[:contracts].should == [@contract]
    end
  end

end
