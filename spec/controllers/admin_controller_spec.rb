require File.dirname(__FILE__) + '/../spec_helper'
describe AdminController do
  before(:each) do
    controller.stub!(:login_required)
    controller.stub!(:authorized?)
    @line_item ||= mock_model(LineItem, :serial_num => "MOCKSN")
    @contract ||= mock_model(Contract, :id => 1, :line_items => [@line_item])
    @contract2 ||= mock_model(Contract, :id => 2, :line_items => [@line_item])
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
    it "should assign found contracts to @contracts" do
      Contract.stub!(:find).and_return(@contract)
      Contract.should_receive(:find).with(1).and_return(@contract)
      @contract.should_receive(:line_items).and_return([@line_item])
      @line_item.should_receive(:serial_num).and_return("MOCKSN")
      Contract.should_receive(:serial_search).with("MOCKSN").and_return([@contract2])
      get :check_for_renewals, "id" => "1"
      assigns[:id].should == 1
      assigns[:contract].should == @contract
      assigns[:contracts].should == [@contract2]
    end
    it "should do nothing when an invalid id is passed" do
      get :check_for_renewals, :params => {"id" => "blah"}
      assigns[:contracts].should == []
    end
  end

end
