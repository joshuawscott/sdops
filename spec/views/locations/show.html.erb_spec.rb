require File.dirname(__FILE__) + '/../../spec_helper'

describe "/locations/show.html.erb" do
  include LocationsHelper
  
  before(:each) do
    @location = mock_model(Location)
    @location.stub!(:name).and_return("MyString")
    @location.stub!(:description).and_return("MyString")
    @location.stub!(:data).and_return("MyText")
    @location.stub!(:resource_id).and_return("1")
    @location.stub!(:resource_type).and_return("MyString")

    assigns[:location] = @location
  end

  it "should render attributes in <p>" do
    render "/locations/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
    response.should have_text(/MyString/)
  end
end

