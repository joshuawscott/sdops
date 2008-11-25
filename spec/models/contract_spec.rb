require File.dirname(__FILE__) + '/../spec_helper'

describe Contract do
  before(:each) do
    @contract = Contract.new
    @contract.stub!(:sdc_ref).and_return("1")
    @contract.stub!(:description).and_return("1")
    @contract.stub!(:sales_rep_id).and_return("1")
    @contract.stub!(:sales_office).and_return("1")
    @contract.stub!(:support_office).and_return("1")
    @contract.stub!(:account_id).and_return("1")
    @contract.stub!(:cust_po_num).and_return("1")
    @contract.stub!(:payment_terms).and_return("1")
    @contract.stub!(:platform).and_return("1")
    @contract.stub!(:revenue).and_return("1")
    @contract.stub!(:annual_hw_rev).and_return("1")
    @contract.stub!(:annual_sw_rev).and_return("1")
    @contract.stub!(:annual_ce_rev).and_return("1")
    @contract.stub!(:annual_sa_rev).and_return("1")
    @contract.stub!(:annual_dr_rev).and_return("1")
    @contract.stub!(:discount_pref_hw).and_return("1")
    @contract.stub!(:discount_pref_sw).and_return("1")
    @contract.stub!(:discount_prepay).and_return("1")
    @contract.stub!(:discount_multiyear).and_return("1")
    @contract.stub!(:discount_ce_day).and_return("1")
    @contract.stub!(:discount_sa_day).and_return("1")
    @contract.stub!(:start_date).and_return("1")
    @contract.stub!(:end_date).and_return("1")
    @contract.stub!(:multiyr_end).and_return("1")
    @contract.stub!(:expired).and_return("1")
    @contract.stub!(:hw_support_level_id).and_return("1")
    @contract.stub!(:sw_support_level_id).and_return("1")
    @contract.stub!(:updates).and_return("1")
    @contract.stub!(:ce_days).and_return("1")
    @contract.stub!(:sa_days).and_return("1")
  end

  it "should be valid" do
    @contract.should be_valid
  end

end



