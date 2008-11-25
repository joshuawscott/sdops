require File.dirname(__FILE__) + '/../spec_helper'

describe Dropdown do
  before(:each) do
    @dropdown = Dropdown.new
  end

  it "should be valid" do
    @dropdown.should be_valid
  end
end
