require 'spec_helper'

describe Goal do
  before(:each) do
    @valid_attributes = {
      :type => "value for type",
      :sales_office => "value for sales_office",
      :sales_office_name => "value for sales_office_name",
      :amount => 9.99,
      :start_date => Date.today,
      :end_date => Date.today,
      :periodicity => "value for periodicity"
    }
  end

  it "should create a new instance given valid attributes" do
    Goal.create!(@valid_attributes)
  end
end
