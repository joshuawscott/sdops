require File.dirname(__FILE__) + '/../../spec_helper'

describe "/opportunities/edit.html.erb" do
  include OpportunitiesHelper
  
  before do
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

  it "should render edit form" do
    render "/opportunities/edit.html.erb"
    
    response.should have_tag("form[action=#{opportunity_path(@opportunity)}][method=post]") do
      with_tag('input#opportunity_account_name[name=?]', "opportunity[account_name]")
      with_tag('input#opportunity_opp_type[name=?]', "opportunity[opp_type]")
      with_tag('input#opportunity_name[name=?]', "opportunity[name]")
      with_tag('textarea#opportunity_description[name=?]', "opportunity[description]")
      with_tag('input#opportunity_revenue[name=?]', "opportunity[revenue]")
      with_tag('input#opportunity_cogs[name=?]', "opportunity[cogs]")
      with_tag('input#opportunity_probability[name=?]', "opportunity[probability]")
      with_tag('input#opportunity_status[name=?]', "opportunity[status]")
      with_tag('input#opportunity_modified_by[name=?]', "opportunity[modified_by]")
    end
  end
end


