require File.dirname(__FILE__) + '/../../spec_helper'

describe "/import/index.html.haml" do
  include ImportHelper
  
  before do
    @sugar_accts = ["4753a639-0860-893c-a2d4-46001201c5df|22squared",'22squared'],
                    ["588c4d1e-e94f-d8fd-319e-46c61ff09aeb|A.M.S. Exotics",'A.M.S. Exotics'],
                    ["cac9df32-29ea-17ea-7379-4485e8ba3fe0|AAA of Arizona",'AAA of Arizona']]

    assigns[:sugar_accts] = @sugar_accts
  end
  
  it "should render the import form" do
    render "import/index.html.haml"
    response.should have_tag("input")

  end
  
end
#<SugarAcct id: "6f3d90de-b914-8deb-0bfb-469cb36b7151|Wharton Co. Jr...", name: "Wharton Co. Jr. College">
#<SugarAcct id: "1da63bb2-5632-fedf-ccd1-4554dd2c8183|WPAHS", name: "WPAHS">
#<SugarAcct id: "8bcbc318-a80a-1eec-7980-46e7f9b5bca1|YearOne", name: "YearOne">
