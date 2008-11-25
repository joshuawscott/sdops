require File.dirname(__FILE__) + '/../../spec_helper'
require 'rubygems'
require 'ruby-debug'

describe "/dropdowns/index.html.erb" do
  include DropdownsHelper

  before do
    dropdowns_98 = mock_model(Dropdown)
    dropdowns_98.stub!(:dd_name).and_return("support_type")
    dropdowns_98.stub!(:filter).and_return("hardware")
    dropdowns_98.stub!(:label).and_return("24x7")
    dropdowns_98.stub!(:sort_order).and_return("1")
    
    dropdowns_99 = mock_model(Dropdown)
    dropdowns_99.stub!(:dd_name).and_return("support_type")
    dropdowns_99.stub!(:filter).and_return("hardware")
    dropdowns_99.stub!(:label).and_return("13x5")
    dropdowns_99.stub!(:sort_order).and_return("2")

    assigns[:dropdowns] = [dropdowns_98, dropdowns_99]
  end

  it "should render list of dropdowns" do
    render "/dropdowns/index.html.erb"
    response.should have_tag("tr>td", "support_type")
    response.should have_tag("tr>td", "hardware")
    response.should have_tag("tr>td", "24x7")
  end
end

