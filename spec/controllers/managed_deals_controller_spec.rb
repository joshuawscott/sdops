require 'spec_helper'

describe ManagedDealsController do
  before(:each) do
    controller.stub!(:login_required)
  end

  def mock_managed_deal(stubs={})
    @mock_managed_deal ||= mock_model(ManagedDeal, stubs)
  end
  #Delete this example and add some real ones
  it "should use ManagedDealsController" do
    controller.should be_an_instance_of(ManagedDealsController)
  end

  describe 'new' do
    it "should create a new managed deal" do
      ManagedDeal.stub(:new).and_return(mock_managed_deal)
      assigns[:managed_deal].should == mock_managed_deal
    end
  end

end
