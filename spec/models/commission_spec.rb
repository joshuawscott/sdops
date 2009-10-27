require 'spec_helper'

describe Commission do
  before(:each) do
    @valid_attributes = {
      :commissionable_id => 1,
      :amount_percentage => 9.99,
      :approval => "value for approval",
      :approval_date => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Commission.create!(@valid_attributes)
  end
end
