require File.dirname(__FILE__) + '/../../spec_helper'

describe "/contracts/index.html.haml" do
  include ContractsHelper
  
  before do
    contract_98 = mock_model(Contract)
    contract_98.should_receive(:sdc_ref).and_return("MyString")
    contract_98.should_receive(:description).and_return("MyString")
    contract_98.should_receive(:sales_rep_name).and_return("Troy")
    contract_99 = mock_model(Contract)
    contract_99.should_receive(:sdc_ref).and_return("MyString")
    contract_99.should_receive(:description).and_return("MyString")
    contract_99.should_receive(:sales_rep_name).and_return("Josh")

    assigns[:contracts] = [contract_98, contract_99]
  end

  it "should render list of contracts" do
    render "contracts/index.html.haml"
    response.should have_tag("tr>td", "MyString", "Troy")
    response.should have_tag("tr>td", "MyString", "Troy")
    response.should have_tag("tr>td", "MyString", "Troy")

  end
end
