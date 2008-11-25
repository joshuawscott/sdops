require File.dirname(__FILE__) + '/../../spec_helper'

describe "/contracts/edit.html.haml" do
  include ContractsHelper

  before do
    @contract = mock_model(Contract)
    @contract.stub!(:sdc_ref).and_return("MyString")
    @contract.stub!(:description).and_return("MyString")
    @contract.stub!(:sales_rep_id).and_return("1")
    @contract.stub!(:sales_office).and_return("Dallas")
    @contract.stub!(:account_id).and_return("MyString")
    @contract.stub!(:account_name).and_return("MyString")
    @contract.stub!(:cust_po_num).and_return("MyString")
    @contract.stub!(:payment_terms).and_return("MyString")
    @contract.stub!(:platform).and_return(false)
    @contract.stub!(:revenue).and_return("MyString")
    @contract.stub!(:annual_hw_rev).and_return("1.5")
    @contract.stub!(:annual_sw_rev).and_return("1.5")
    @contract.stub!(:annual_ce_rev).and_return("1.5")
    @contract.stub!(:annual_sa_rev).and_return("1.5")
    @contract.stub!(:annual_dr_rev).and_return("1.5")
    @contract.stub!(:start_date).and_return(Date.today)
    @contract.stub!(:end_date).and_return(Date.today)
    @contract.stub!(:multiyr_end).and_return(Date.today)
    @contract.stub!(:expired).and_return("MyString")
    @contract.stub!(:hw_support_level_id).and_return("1")
    @contract.stub!(:sw_support_level_id).and_return("1")
    @contract.stub!(:updates).and_return("MyString")
    @contract.stub!(:ce_days).and_return("1")
    @contract.stub!(:sa_days).and_return("1")
    @contract.stub!(:discount_pref_hw).and_return("1.5")
    @contract.stub!(:discount_pref_sw).and_return("1.5")
    @contract.stub!(:discount_prepay).and_return("1.5")
    @contract.stub!(:discount_multiyear).and_return("1.5")
    @contract.stub!(:discount_ce_day).and_return("1.5")
    @contract.stub!(:discount_sa_day).and_return("1.5")
    @contract.stub!(:support_office).and_return("MyString")
    @contract.stub!(:replacement_sdc_ref).and_return("MyString")
    assigns[:contract] = @contract

    @offices = mock("offices", :id => 1, :label => "Dallas")
    @offices.stub!(:map).and_return([1,"Dallas"])
    assigns[:offices] = @offices

    @pay_terms = mock("pay_terms", :id => 1, :label => "annual")
    @pay_terms.stub!(:map).and_return([1,"annual"])
    assigns[:pay_terms] = @pay_terms

    @reps = mock("reps", :id => 1, :label => "troy")
    @reps.stub!(:map).and_return([1,"troy"])
    assigns[:reps] = @reps

    @types_hw = mock("types_hw", :id => 1, :label => "24x7")
    @types_hw.stub!(:map).and_return([1,"24x7"])
    assigns[:types_hw] = @types_hw

    @types_sw = mock("types_sw", :id => 1, :label => "24x7")
    @types_sw.stub!(:map).and_return([1,"24x7"])
    assigns[:types_sw] = @types_sw

    end

  it "should render edit form" do
    render "contracts/edit.html.haml"

    response.should have_tag("form[action=#{contract_path(@contract)}][method=post]") do
      with_tag("input#contract_sdc_ref[name=?]", "contract[sdc_ref]")
      with_tag("input#contract_description[name=?]", "contract[description]")
      with_tag("input#contract_cust_po_num[name=?]", "contract[cust_po_num]")
      with_tag("select#contract_payment_terms[name=?]", "contract[payment_terms]")
      with_tag("select#contract_platform[name=?]", "contract[platform]")
      with_tag("input#contract_replacement_sdc_ref[name=?]", "contract[replacement_sdc_ref]")
      with_tag("select#contract_sales_office[name=?]", "contract[sales_office]")
      with_tag("select#contract_support_office[name=?]", "contract[support_office]")
      with_tag("input#contract_revenue[name=?]", "contract[revenue]")
      with_tag("input#contract_annual_hw_rev[name=?]", "contract[annual_hw_rev]")
      with_tag("input#contract_annual_sw_rev[name=?]", "contract[annual_sw_rev]")
      with_tag("input#contract_annual_ce_rev[name=?]", "contract[annual_ce_rev]")
      with_tag("input#contract_annual_sa_rev[name=?]", "contract[annual_sa_rev]")
      with_tag("input#contract_annual_dr_rev[name=?]", "contract[annual_dr_rev]")
      with_tag("input#contract_discount_pref_hw[name=?]", "contract[discount_pref_hw]")
      with_tag("input#contract_discount_pref_sw[name=?]", "contract[discount_pref_sw]")
      with_tag("input#contract_discount_prepay[name=?]", "contract[discount_prepay]")
      with_tag("input#contract_discount_multiyear[name=?]", "contract[discount_multiyear]")
      with_tag("input#contract_discount_ce_day[name=?]", "contract[discount_ce_day]")
      with_tag("input#contract_discount_sa_day[name=?]", "contract[discount_sa_day]")
      with_tag("select#contract_updates[name=?]", "contract[updates]")
      with_tag("input#contract_ce_days[name=?]", "contract[ce_days]")
      with_tag("input#contract_sa_days[name=?]", "contract[sa_days]")
      with_tag("select#contract_expired[name=?]", "contract[expired]")
    end
  end
end
