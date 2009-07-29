require File.dirname(__FILE__) + '/../spec_helper'

describe HwSupportPricesController, "GET index" do

  before(:each) do
    controller.stub!(:login_required)
  end

  context "initial visit" do
    it "should render successfully without parameters" do
      get :index
      response.should render_template("hw_support_prices/index")
      response.should be_success
    end
  end

  context "main search" do

    it "should render index.html.haml" do
      get :index, :part_number => 'A6144', :description => '', :commit => 'Search'
      response.should render_template("hw_support_prices/index")
      response.should be_success
    end

    it "should assign productnumber and description for the view" do
      get :index, :part_number => 'A6144', :description => 'L3000'
      assigns[:part_number].should == "A6144"
      assigns[:description].should == "L3000"
    end

    it "should find by productnumber" do
      HwSupportPrice.should_receive(:search).with('A6144', '')
      get :index, :part_number => 'A6144', :description => ''
    end

    it "should assign the found items to @items" do
      @items = [mock(HwSupportPrice)]
      HwSupportPrice.should_receive(:search).and_return(@items)
      get :index, :part_number => 'A6144', :description => ''
      assigns[:items].should == @items
    end
  end
end

describe HwSupportPricesController, "POST create" do

  before(:each) do
    controller.stub!(:login_required)
    @hw_support_price = mock_model(HwSupportPrice, :save => nil)
    HwSupportPrice.stub!(:new).and_return @hw_support_price
  end

  it "should create a new HwSupportPrice" do
    HwSupportPrice.should_receive(:new).with("part_number" => "A6144A").and_return @hw_support_price
    post :create, :hw_support_price => {"part_number" => "A6144A"}
  end

  it "should save the new price" do
    HwSupportPrice.stub!(:new).and_return @hw_support_price
    @hw_support_price.should_receive :save
    post :create
  end

  context "when it saves successfully" do
    before(:each) do
      @hw_support_price.stub!(:save).and_return true
    end

    it "should redirect to the new form again" do
      post :create
      response.should redirect_to(new_hw_support_price_path)
    end

    it "should display a success message" do
      post :create
      flash[:notice].should == "The price was saved successfully."
    end

  end

  context "when it fails to save successfully" do
    before(:each) do
      @hw_support_price.stub!(:save).and_return false
    end

    it "should assign @hw_support_price" do
      post :create
      assigns[:hw_support_price].should == @hw_support_price
    end

    it "should render the new template" do
      post :create
      response.should render_template("new")
    end

  end

end
