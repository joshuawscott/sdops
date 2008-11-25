require File.dirname(__FILE__) + '/../../spec_helper'

describe "/locations/index.html.erb" do
  include LocationsHelper
  
  before(:each) do
    location_98 = mock_model(Location)
    location_98.should_receive(:name).and_return("MyString")
    location_98.should_receive(:description).and_return("MyString")
    location_98.should_receive(:data).and_return("MyText")
    location_98.should_receive(:resource_id).and_return("1")
    location_98.should_receive(:resource_type).and_return("MyString")
    location_99 = mock_model(Location)
    location_99.should_receive(:name).and_return("MyString")
    location_99.should_receive(:description).and_return("MyString")
    location_99.should_receive(:data).and_return("MyText")
    location_99.should_receive(:resource_id).and_return("1")
    location_99.should_receive(:resource_type).and_return("MyString")

    assigns[:locations] = [location_98, location_99]
  end

  it "should render list of locations" do
    render "/locations/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

