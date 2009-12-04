require File.dirname(__FILE__) + '/../spec_helper'
describe AdminController do
  before(:each) do
    controller.stub!(:login_required)
    controller.stub!(:authorized?)
    @contract = mock_model(Contract)
  end

  describe "GET missing_subcontracts" do
    before :each do
      Contract.stub!(:missing_subcontracts).and_return([@contract])
    end
    it "finds contracts using missing_subcontracts" do
      Contract.should_receive(:missing_subcontracts).and_return([@contract])
      get :missing_subcontracts
    end
    it "should assign found contracts to @contracts" do
      get :missing_subcontracts
      assigns[:contracts].should == [@contract]
    end
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
end
