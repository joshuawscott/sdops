require 'spec_helper'

describe Manufacturer do
  before(:each) do
    @valid_attributes = {
      :name => "name"
    }
  end

  it "should create a new instance given valid attributes" do
    Manufacturer.create!(@valid_attributes)
  end
end
