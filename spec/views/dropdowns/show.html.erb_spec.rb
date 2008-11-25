require File.dirname(__FILE__) + '/../../spec_helper'

describe "/dropdowns/show.html.erb" do
  include DropdownsHelper
  
  before do
    @dropdowns = mock_model(Dropdown)
    @dropdowns.stub!(:dd_name).and_return("support_type")
    @dropdowns.stub!(:filter).and_return("hardware")
    @dropdowns.stub!(:label).and_return("24x7")
    @dropdowns.stub!(:sort_order).and_return("1")

    assigns[:dropdowns] = @dropdowns
  end

  it "should render attributes in <p>" do
    render "/dropdowns/show.html.erb"
    response.should have_text(/support/)
    response.should have_text(/hardware/)
    response.should have_text(/24x7/)
    response.should have_text(/1/)
  end
end

