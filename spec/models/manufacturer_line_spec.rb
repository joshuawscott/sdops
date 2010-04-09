require 'spec_helper'

describe ManufacturerLine do
  before(:each) do
    @valid_attributes = {
      :name => "name",
      :manufacturer_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ManufacturerLine.create!(@valid_attributes)
  end
end
