require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LineItemsController do
  def mock_contract(stubs={})
    @mock_contract ||= mock_model(Contract, stubs)
  end
  def mock_line_item(stubs={})
    stubs[:support_deal] ||= mock_support_deal
    @mock_line_item ||= mock_model(LineItem, stubs)
  end
  def mock_support_deal(stubs={})
    @mock_support_deal ||= mock_model(SupportDeal, stubs)
  end
  def mock_hw_support_price(stubs={})
    stubs[:list_price] ||= 100.0
    stubs[:part_number] ||= "A6144A"
    stubs[:list_price=] ||= 100.0
    @mock_hw_support_price ||= mock_model(HwSupportPrice, stubs)
  end
  before(:each) do
    controller.stub!(:login_required)
  end
  describe "pull_pn_form_data" do
    it "should retrieve the price" do
      #mock_support_deal.should_receive(:id).and_return(1)
      #mock_line_item.should_receive(:id).and_return(1)
      mock_support_deal.should_receive(:list_price_increase).and_return(0.0)
      mock_support_deal.should_receive(:hw_support_level_multiplier).and_return(1.0)
      SupportDeal.stub!(:find).and_return(mock_support_deal)
      HwSupportPrice.stub(:current_list_price).and_return(mock_hw_support_price)
      LineItem.stub!(:find).and_return(mock_line_item)
      LineItem.stub!(:return_current_info).and_return(mock_hw_support_price)
      xhr :post, :form_pull_pn_data, :format => 'js', :id => mock_line_item.id, :support_deal_id => mock_support_deal.id, :product_num => "A6144A", :support_type => 'HW'
      assigns[:new_info].class.should == HwSupportPrice
    end
  end

  describe "show" do
    it "should assign the line item to @line_item" do
      Contract.stub!(:find).and_return(mock_contract)
      SupportDeal.stub!(:find).and_return(mock_support_deal)
      LineItem.stub!(:find).and_return(mock_line_item)
      get :show
      assigns[:line_item].should == mock_line_item
    end
  end
end