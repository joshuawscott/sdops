require File.dirname(__FILE__) + '/../spec_helper'

describe SugarAcct do
  before(:each) do
    @sugar_acct = SugarAcct.new
  end

  it "should be valid" do
    @sugar_acct.should be_valid
  end
end
