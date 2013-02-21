require 'spec_helper'

describe "/footprints_categories/new.html.erb" do
  include FootprintsCategoriesHelper

  before(:each) do
    assigns[:footprints_category] = stub_model(FootprintsCategory,
      :new_record? => true,
      :subsystem => "value for subsystem",
      :main_category => "value for main_category"
    )
  end

  it "renders new footprints_category form" do
    render

    response.should have_tag("form[action=?][method=post]", footprints_categories_path) do
      with_tag("input#footprints_category_subsystem[name=?]", "footprints_category[subsystem]")
      with_tag("input#footprints_category_main_category[name=?]", "footprints_category[main_category]")
    end
  end
end
