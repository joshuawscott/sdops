require 'spec_helper'

describe Invoice do
  before(:each) do
    @valid_attributes = {
      :invoiceable_id => 1,
      :invoiceable_type => "value for invoiceable_type",
      :appgen_cust_number => 1,
      :invoice_number => "value for invoice_number",
      :invoice_date => Date.today,
      :invoice_amount => 9.99
    }
  end

  it "should create a new instance given valid attributes" do
    Invoice.create!(@valid_attributes)
  end
end
