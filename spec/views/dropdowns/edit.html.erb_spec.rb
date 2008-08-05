require File.dirname(__FILE__) + '/../../spec_helper'

describe "/dropdowns/edit.html.erb" do
  include DropdownsHelper
  
  before do
    @dropdowns = mock_model(Dropdown)
    @dropdowns.stub!(:dd_name).and_return("support_type")
    @dropdowns.stub!(:filter).and_return("hardware")
    @dropdowns.stub!(:label).and_return("24x7 Hardware")
    @dropdowns.stub!(:sort_order).and_return("1")
    assigns[:dropdowns] = @dropdowns
  end

  it "should render edit form" do
    render "/dropdowns/edit.html.erb"
    
    response.should have_tag("form[action=#{dropdown_path(@dropdowns)}][method=post]") do
      with_tag('input#dropdown_dd_name[name=?]', "dropdown[dd_name]")
      with_tag('input#dropdown_filter[name=?]', "dropdown[filter]")
      with_tag('input#dropdown_label[name=?]', "dropdown[label]")
    end
  end
end


