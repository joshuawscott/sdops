require File.dirname(__FILE__) + '/../spec_helper'

describe SwSupportPricesController, "GET index" do

  before(:each) do
    controller.stub!(:login_required)
  end

  context "initial visit" do
    it "should render successfully without parameters" do
      get :index
      response.should render_template("sw_support_prices/index")
      response.should be_success
    end
  end

  context "main search" do

    it "should render index.html.haml" do
      get :index, :productnumber => 'A6144', :description => '', :commit => 'Search'
      response.should render_template("sw_support_prices/index")
      response.should be_success
    end

    it "should assign productnumber and description for the view" do
      get :index, :productnumber => 'A6144', :description => 'L3000'
      assigns[:productnumber].should == "A6144"
      assigns[:description].should == "L3000"
    end

    it "should find by productnumber" do
      SwSupportPrice.should_receive(:search).with('A6144', '')
      get :index, :productnumber => 'A6144', :description => ''
    end

    it "should assign the found items to @items" do
      @items = [mock(SwSupportPrice)]
      SwSupportPrice.should_receive(:search).and_return(@items)
      get :index, :productnumber => 'A6144', :description => ''
      assigns[:items].should == @items
    end

  end
end

describe SwSupportPricesController, "POST create" do

  before(:each) do
    controller.stub!(:login_required)
    @sw_support_price = mock_model(SwSupportPrice, :save => nil)
    SwSupportPrice.stub!(:new).and_return @sw_support_price
  end

  it "should create a new SwSupportPrice" do
    SwSupportPrice.should_receive(:new).with("part_number" => "A6144A").and_return @sw_support_price
    post :create, :sw_support_price => {"part_number" => "A6144A"}
  end

  it "should save the new price" do
    SwSupportPrice.stub!(:new).and_return @sw_support_price
    @sw_support_price.should_receive :save
    post :create
  end

  context "when it saves successfully" do
    before(:each) do
      @sw_support_price.stub!(:save).and_return true
    end

    it "should redirect to the new form again" do
      post :create
      response.should redirect_to(new_sw_support_price_path)
    end

    it "should display a success message" do
      post :create
      flash[:notice].should == "The price was saved successfully."
    end

  end

  context "when it fails to save successfully" do
    before(:each) do
      @sw_support_price.stub!(:save).and_return false
    end

    it "should assign @sw_support_price" do
      post :create
      assigns[:sw_support_price].should == @sw_support_price
    end

    it "should render the new template" do
      post :create
      response.should render_template("new")
    end

  end

end
