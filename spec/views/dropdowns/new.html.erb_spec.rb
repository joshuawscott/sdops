require File.dirname(__FILE__) + '/../../spec_helper'

describe "/dropdowns/new.html.erb" do
  include DropdownsHelper
  
  before do
    @dropdowns = mock_model(Dropdown)
    @dropdowns.stub!(:new_record?).and_return(true)
    @dropdowns.stub!(:dd_name).and_return("support_type")
    @dropdowns.stub!(:filter).and_return("MyString")
    @dropdowns.stub!(:label).and_return("MyString")
    @dropdowns.stub!(:sort_order).and_return("1")
    assigns[:dropdowns] = @dropdowns
  end

  it "should render new form" do
    render "/dropdowns/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", dropdowns_path) do
      with_tag("input#dropdown_dd_name[name=?]", "dropdown[dd_name]")
      with_tag("input#dropdown_filter[name=?]", "dropdown[filter]")
      with_tag("input#dropdown_label[name=?]", "dropdown[label]")
      with_tag("input#dropdown_sort_order[name=?]", "dropdown[sort_order]")
    end
  end
end


