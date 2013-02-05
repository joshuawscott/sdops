require 'spec_helper'

describe FootprintsCategory do
  before(:each) do
    @valid_attributes = {
      :subsystem => "value for subsystem",
      :main_category => "value for main_category"
    }
  end

  it "should create a new instance given valid attributes" do
    FootprintsCategory.create!(@valid_attributes)
  end
end
