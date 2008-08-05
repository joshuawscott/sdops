require File.dirname(__FILE__) + '/../../spec_helper'

describe "/locations/edit.html.erb" do
  include LocationsHelper
  
  before do
    @location = mock_model(Location)
    @location.stub!(:name).and_return("MyString")
    @location.stub!(:description).and_return("MyString")
    @location.stub!(:data).and_return("MyText")
    @location.stub!(:resource_id).and_return("1")
    @location.stub!(:resource_type).and_return("MyString")
    assigns[:location] = @location
  end

  it "should render edit form" do
    render "/locations/edit.html.erb"
    
    response.should have_tag("form[action=#{location_path(@location)}][method=post]") do
      with_tag('input#location_name[name=?]', "location[name]")
      with_tag('input#location_description[name=?]', "location[description]")
      with_tag('textarea#location_data[name=?]', "location[data]")
      with_tag('input#location_resource_type[name=?]', "location[resource_type]")
    end
  end
end


