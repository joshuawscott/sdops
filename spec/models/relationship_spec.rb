require File.dirname(__FILE__) + '/../spec_helper'

describe Relationship do
  before(:each) do
    @relationship = Relationship.new
  end

  it "should be valid" do
    @relationship.should be_valid
  end
end
