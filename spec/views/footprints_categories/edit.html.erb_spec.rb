require 'spec_helper'

describe "/footprints_categories/edit.html.erb" do
  include FootprintsCategoriesHelper

  before(:each) do
    assigns[:footprints_category] = @footprints_category = stub_model(FootprintsCategory,
      :new_record? => false,
      :subsystem => "value for subsystem",
      :main_category => "value for main_category"
    )
  end

  it "renders the edit footprints_category form" do
    render

    response.should have_tag("form[action=#{footprints_category_path(@footprints_category)}][method=post]") do
      with_tag('input#footprints_category_subsystem[name=?]', "footprints_category[subsystem]")
      with_tag('input#footprints_category_main_category[name=?]', "footprints_category[main_category]")
    end
  end
end
