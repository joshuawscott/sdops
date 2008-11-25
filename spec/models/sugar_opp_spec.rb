require File.dirname(__FILE__) + '/../spec_helper'

describe SugarOpp do
  before(:each) do
    @sugar_opp = SugarOpp.new
  end

  it "should be valid" do
    @sugar_opp.should be_valid
  end
end
