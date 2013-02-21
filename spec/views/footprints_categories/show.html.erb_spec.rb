require 'spec_helper'

describe "/footprints_categories/show.html.erb" do
  include FootprintsCategoriesHelper
  before(:each) do
    assigns[:footprints_category] = @footprints_category = stub_model(FootprintsCategory,
      :subsystem => "value for subsystem",
      :main_category => "value for main_category"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ subsystem/)
    response.should have_text(/value\ for\ main_category/)
  end
end
