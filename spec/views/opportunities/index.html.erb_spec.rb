require File.dirname(__FILE__) + '/../../spec_helper'

describe "/opportunities/index.html.erb" do
  include OpportunitiesHelper
  
  before(:each) do
    opportunity_98 = mock_model(Opportunity)
    opportunity_98.should_receive(:sugar_id).and_return("MyString")
    opportunity_98.should_receive(:account_id).and_return("MyString")
    opportunity_98.should_receive(:account_name).and_return("MyString")
    opportunity_98.should_receive(:opp_type).and_return("MyString")
    opportunity_98.should_receive(:name).and_return("MyString")
    opportunity_98.should_receive(:description).and_return("MyText")
    opportunity_98.should_receive(:revenue).and_return("1")
    opportunity_98.should_receive(:cogs).and_return("1")
    opportunity_98.should_receive(:probability).and_return("1")
    opportunity_98.should_receive(:status).and_return("MyString")
    opportunity_98.should_receive(:modified_by).and_return("MyString")
    opportunity_98.should_receive(:created_at).and_return(Time.now)
    opportunity_98.should_receive(:updated_at).and_return(Time.now)
    opportunity_99 = mock_model(Opportunity)
    opportunity_99.should_receive(:sugar_id).and_return("MyString")
    opportunity_99.should_receive(:account_id).and_return("MyString")
    opportunity_99.should_receive(:account_name).and_return("MyString")
    opportunity_99.should_receive(:opp_type).and_return("MyString")
    opportunity_99.should_receive(:name).and_return("MyString")
    opportunity_99.should_receive(:description).and_return("MyText")
    opportunity_99.should_receive(:revenue).and_return("1")
    opportunity_99.should_receive(:cogs).and_return("1")
    opportunity_99.should_receive(:probability).and_return("1")
    opportunity_99.should_receive(:status).and_return("MyString")
    opportunity_99.should_receive(:modified_by).and_return("MyString")
    opportunity_99.should_receive(:created_at).and_return(Time.now)
    opportunity_99.should_receive(:updated_at).and_return(Time.now)

    assigns[:opportunities] = [opportunity_98, opportunity_99]
  end

  it "should render list of opportunities" do
    render "/opportunities/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

