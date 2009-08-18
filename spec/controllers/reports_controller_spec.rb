require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe ReportsController, "index" do
  before(:each) do
    controller.stub!(:login_required)
    @contract = mock_model(Contract)
    Contract.stub!(:all_revenue).and_return(@contract)
    Contract.stub!(:revenue_by_office_by_type).and_return([@contract])
  end

  it "finds all_revenue without parameters when a blank date is searched for" do
    Contract.should_receive(:all_revenue).with(nil)
    get :index, :date => ''
  end

  it "finds all_revenue with a date when a date is searched for" do
    date = Date.parse('2009-08-01')
    Contract.should_receive(:all_revenue).with(date)
    get :index, :date => '08/01/2009'
  end

  it "finds all_revenue without parameters when loading the page without a search" do
    Contract.should_receive(:all_revenue).with(nil)
    get :index
  end

  it "assigns @all_revenue" do
    get :index
    assigns[:all_revenue].should == @contract
  end

  it "finds revenue_by_office_by_type without parameters when a blank date is searched for" do
    Contract.should_receive(:revenue_by_office_by_type).with(nil)
    get :index, :date => ''
  end

  it "finds revenue_by_office_by_type with a date when a date is searched for" do
    date = Date.parse('2009-08-01')
    Contract.should_receive(:revenue_by_office_by_type).with(date)
    get :index, :date => '08/01/2009'
  end

  it "finds revenue_by_office_by_type without parameters when loading the page without a search" do
    Contract.should_receive(:revenue_by_office_by_type).with(nil)
    get :index
  end

  it "assigns @revenue_by_office_by_type" do
    get :index
    assigns[:revenue_by_office_by_type].should == [@contract]
  end

end
