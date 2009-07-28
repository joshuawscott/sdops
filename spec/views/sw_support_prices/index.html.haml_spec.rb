require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
describe 'sw_support_prices/index.html.haml' do
  context "first viewing the page" do
    before(:each) do
      render "sw_support_prices/index.html.haml"
    end
    it "should display the search boxes" do
      response.should contain("Part Number")
      response.should contain("Description")
    end

    it "should display the header columns" do
      response.should contain("Confirmation Date")
      response.should contain("Effective Date")
      response.should contain("Phone Price")
      response.should contain("Update Price")
      response.should contain("Total Price")
    end

    it "should have a search form" do
      response.should have_tag("form[method=get]", :action => sw_support_prices_path) do |form|
        form.should have_tag("input[type=submit]",
          :name => "commit",
          :value => "Search")
        form.should have_tag("input[type=text]",
          :name => "description")
        form.should have_tag("input[type=text]",
          :name => "productnumber")
      end
    end
  end
  context "searching for a part" do
    before(:each) do
      @items = [
        mock_model(SwSupportPrice,
          :part_number => 'A6144A',
          :description => 'L3000',
          :phone_price => 300.0,
          :update_price => 200.0,
          :list_price => 100.0,
          :modified_at => '1970-01-01',
          :confirm_date => '1970-01-01'),
        mock_model(SwSupportPrice,
          :part_number => 'A5522A',
          :description => 'Processor',
          :phone_price => 75.0,
          :update_price => 25.0,
          :list_price => 100.0,
          :modified_at => '1970-01-01',
          :confirm_date => '1970-01-01'),
        ]
      assigns[:items] = @items
      render '/sw_support_prices/index.html.haml'
    end

    it "check setup" do
      @items[0].part_number.should == 'A6144A'
    end

    it "should display the items found in a table" do
      response.should have_tag("table") do |table|
        table.should have_tag("tbody") do |tbody|
          tbody.should contain("A6144A")
          tbody.should contain("Processor")
          tbody.should contain("1970-01-01")
          tbody.should contain("$75.00")
          tbody.should contain("$25.00")
          tbody.should contain("$100.00")
        end
      end
    end
  end
end
