require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe LineItemsController, "pull_pn_form_data" do
  before(:each) do
    controller.stub!(:login_required)
    @contract = mock("contract")
    @line_item = mock("line_item")
  end
  it "should retrieve the price" do
    @contract.should_receive(:id).and_return(1)
    @line_item.should_receive(:id).and_return(1)
    Contract.stub!(:find).and_return(@contract)
    LineItem.stub!(:find).and_return(@line_item)
    LineItem.stub!(:return_current_info).and_return(HwSupportPrice.new(:list_price => 100.0, :part_number => "A6144A"))
    hwprice = HwSupportPrice.new()
    LineItem.stub!(:return_current_info).and_return(hwprice)
    xhr :post, :form_pull_pn_data, :format => 'js', :id => @line_item.id, :contract_id => @contract.id, :product_num => "A6144A", :support_type => 'HW'
    assigns[:new_info].class.should == HwSupportPrice
  end

end

