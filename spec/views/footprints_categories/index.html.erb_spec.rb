require 'spec_helper'

describe "/footprints_categories/index.html.erb" do
  include FootprintsCategoriesHelper

  before(:each) do
    assigns[:footprints_categories] = [
      stub_model(FootprintsCategory,
        :subsystem => "value for subsystem",
        :main_category => "value for main_category"
      ),
      stub_model(FootprintsCategory,
        :subsystem => "value for subsystem",
        :main_category => "value for main_category"
      )
    ]
  end

  it "renders a list of footprints_categories" do
    render
    response.should have_tag("tr>td", "value for subsystem".to_s, 2)
    response.should have_tag("tr>td", "value for main_category".to_s, 2)
  end
end
