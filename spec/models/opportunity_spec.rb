require File.dirname(__FILE__) + '/../spec_helper'

describe Opportunity do
  before(:each) do
    @opportunity = Opportunity.new
  end

  it "should be valid" do
    @opportunity.should be_valid
  end
end
