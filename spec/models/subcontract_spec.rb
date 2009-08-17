require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Subcontract do
  before(:each) do
    subcontractor = Factory :subcontractor
    @valid_attributes = {
      :subcontractor_id => subcontractor.id,
      :start_date => Date.parse('2009-01-01'),
      :end_date => Date.parse('2009-12-31')
    }
  end

  it "should create a new instance given valid attributes" do
    Subcontract.create!(@valid_attributes)
  end
end
