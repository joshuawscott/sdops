require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'active_resource/http_mock'
def mock_fbxml_so(options={})
  options.stringify_keys!
  @so =
    [{
      "customer_name" => "Fairfield Residential Carepack June1",
      "customercontact" => "Fairfield Residential LLC",
      "customerpo" => "SAF- Signed",
      "datecompleted" => "2013-06-03T05:00:00Z",
      "datecreated" => "2013-06-03T05:00:00Z",
      "id" => 887,
      "note" => "CAREPACK-5YR\nSAF\n",
      "num" => "20912",
      "salesman" => "lherrin",
      "shiptoaddress" => "400 S. Akard Ste 100",
      "shiptocity" => "Dallas",
      "shiptoname" => "Fairfield Residential LLC",
      "shiptostate" => "TX",
      "shiptozip" => "75202",
      "team_name" => "Fort Worth"
    }.merge(options)]
  @so_in_quarter = [@so[0].merge({"datecreated" => "2011-06-03T05:00:00Z"})]
  req_head = {'Content-Type' => 'application/json'}
  ActiveResource::HttpMock.respond_to do |mock|
    mock.get "/custom_sdops_so.json", req_head, @so.to_json, 200
    mock.get "/custom_sdops_so/887.json", req_head, @so[0].to_json
    mock.get "/custom_sdops_so.json?datecreated_gt=2011-03-31&datecreated_lt=2011-07-01", req_head, @so_in_quarter.to_json
    mock.get "/custom_sdops_so.json?datecreated_gt=2013-03-31&datecreated_lt=2013-07-01", req_head, @so.to_json
  end

end
def mock_fbxml_so_items(first_options={}, second_options={})
  first_options.stringify_keys!
  second_options.stringify_keys!
  @so_items =
    [{
      "adjustamount" => 0.0,
      "adjustpercentage" => 0.0,
      "description" => "DELL POWEREDGE M1000E BLADE ENCLOSURE",
      "id" => 5140,
      "productid" => 29729,
      "productnum" => "SDCDELLPEM1000E",
      "qtyshipped" => nil,
      "qtytofulfill" => 1.0,
      "serialnum" => nil,
      "soid" => 887,
      "solineitem" => 1,
      "totalcost" => 0.0,
      "typeid" => 10,
      "unitprice" => 4454.4
    }.merge(first_options),
    {
      "adjustamount" => 0.0,
      "adjustpercentage" => 0.0,
      "description" => "DELL POWEREDGE M620 BLADE SERVER",
      "id" => 5141,
      "productid" => 29730,
      "productnum" => "SDCDELLPEM620",
      "qtyshipped" => nil,
      "qtytofulfill" => 5.0,
      "serialnum" => nil,
      "soid" => 887,
      "solineitem" => 2,
      "totalcost" => 0.0,
      "typeid" => 10,
      "unitprice" => 1670.4
    }.merge(second_options)]
  @so_items_json = @so_items.to_json
  req_head = {'Content-Type' => 'application/json'}
  typeid_cond = {:typeid => [10,11,12,30,31,80]}.to_query
  ActiveResource::HttpMock.respond_to do |mock|
    mock.get "/custom_sdops_so_item.json", req_head, @so__items_json, 200
    mock.get "/custom_sdops_so_item.json?soid=887&" + typeid_cond, req_head, @so_items.to_json, 200
    mock.get "/custom_sdops_so_item.json?soid=880&" + typeid_cond, req_head, " ", 200
  end

end
describe FishbowlSo do
  describe '#line_items' do
    it "should return the line items" do
      mock_fbxml_so
      fishbowl_so = FishbowlSo.find(887)
      mock_fbxml_so_items
      fishbowl_so_items = FishbowlSoItem.find(:all, :params => {:soid => fishbowl_so.id, :typeid => [10,11,12,30,31,80]})
      fishbowl_so.line_items.should == fishbowl_so_items
    end
  end
  describe '.received_between' do
    it "should find the SOs in the quarter" do
      mock_fbxml_so
      FishbowlSo.received_between(Date.parse('2011-04-01'), Date.parse('2011-06-30'))[0].datecreated.should == Time.parse("2011-06-03T05:00:00Z")
      FishbowlSo.received_between(Date.parse('2013-04-01'), Date.parse('2013-06-30'))[0].datecreated.should == Time.parse("2013-06-03T05:00:00Z")
    end
  end
  describe '#revenue' do
    it "should total the revenue for the items" do
      mock_fbxml_so
      fishbowl_so = FishbowlSo.find(887)
      mock_fbxml_so_items
      expected_revenue = @so_items.sum {|i| i["qtytofulfill"] * i["unitprice"]}
      fishbowl_so.revenue.should == expected_revenue
    end
  end
end