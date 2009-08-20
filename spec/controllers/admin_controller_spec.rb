require File.dirname(__FILE__) + '/../spec_helper'
describe AdminController do
  before(:each) do
    controller.stub!(:login_required)
    controller.stub!(:authorized?)
    @contract = mock_model(Contract)
    Contract.stub!(:missing_subcontracts).and_return([@contract])
  end

  describe "GET missing_subcontracts" do
    it "finds contracts using missing_subcontracts" do
      Contract.should_receive(:missing_subcontracts).and_return([@contract])
      get :missing_subcontracts
    end
    it "should assign found contracts to @contracts" do
      get :missing_subcontracts
      assigns[:contracts].should == [@contract]
    end
  end
  
end
