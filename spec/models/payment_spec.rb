require 'spec_helper'

describe Payment do
  before(:each) do
    @valid_attributes = {
      :appgen_cust_number => 1,
      :payment_number => "value for payment_number",
      :payment_date => Date.today,
      :payment_amount => 9.99
    }
  end

  it "should create a new instance given valid attributes" do
    Payment.create!(@valid_attributes)
  end
end
