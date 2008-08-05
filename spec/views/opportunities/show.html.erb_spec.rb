require File.dirname(__FILE__) + '/../../spec_helper'

describe "/opportunities/show.html.erb" do
  include OpportunitiesHelper
  
  before(:each) do
    @opportunity = mock_model(Opportunity)
    @opportunity.stub!(:sugar_id).and_return("MyString")
    @opportunity.stub!(:account_id).and_return("MyString")
    @opportunity.stub!(:account_name).and_return("MyString")
    @opportunity.stub!(:opp_type).and_return("MyString")
    @opportunity.stub!(:name).and_return("MyString")
    @opportunity.stub!(:description).and_return("MyText")
    @opportunity.stub!(:revenue).and_return("1")
    @opportunity.stub!(:cogs).and_return("1")
    @opportunity.stub!(:probability).and_return("1")
    @opportunity.stub!(:status).and_return("MyString")
    @opportunity.stub!(:modified_by).and_return("MyString")
    @opportunity.stub!(:created_at).and_return(Time.now)
    @opportunity.stub!(:updated_at).and_return(Time.now)

    assigns[:opportunity] = @opportunity
  end

  it "should render attributes in <p>" do
    render "/opportunities/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
  end
end

