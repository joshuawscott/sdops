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
      get :index, :part_number => 'A6144', :description => '', :commit => 'Search'
      response.should render_template("sw_support_prices/index")
      response.should be_success
    end

    it "should assign part_number and description for the view" do
      get :index, :part_number => 'A6144', :description => 'L3000'
      assigns[:part_number].should == "A6144"
      assigns[:description].should == "L3000"
    end

    it "should find by part_number" do
      SwSupportPrice.should_receive(:search).with('A6144', '')
      get :index, :part_number => 'A6144', :description => ''
    end

    it "should assign the found items to @items" do
      @items = [mock(SwSupportPrice)]
      SwSupportPrice.should_receive(:search).and_return(@items)
      get :index, :part_number => 'A6144', :description => ''
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

describe SwSupportPricesController, "POST destroy" do
  before(:each) do
    controller.stub!(:login_required)
    @sw_support_price = mock_model(SwSupportPrice)
    @sw_support_price.stub!(:id).and_return(1)
    SwSupportPrice.stub!(:find).and_return(@sw_support_price)
    @sw_support_price.should_receive(:destroy).and_return(true)
  end
  it "should destroy the instance" do
    post :destroy, :id => @sw_support_price.id
  end
  it "should redirect to the index page" do
    post :destroy, :id => @sw_support_price.id
    response.should redirect_to("sw_support_prices")
  end

end

describe SwSupportPricesController, "GET edit" do

  before(:each) do
    controller.stub!(:login_required)
    @sw_support_price = mock_model(SwSupportPrice)
    @sw_support_price.stub!(:id).and_return(1)
    SwSupportPrice.stub!(:find).and_return(@sw_support_price)
  end

  it "should render the edit page" do
    get :edit, :id => @sw_support_price.id
    response.should render_template("edit")
  end
  it "should find the SwSupportPrice to edit" do
    get :edit, :id => @sw_support_price.id
    assigns[:sw_support_price].should == @sw_support_price
  end
end

describe SwSupportPricesController, "POST update" do

  before(:each) do
    controller.stub!(:login_required)
    @sw_support_price = mock_model(SwSupportPrice)
    @sw_support_price.stub!(:id).and_return(1)
    SwSupportPrice.should_receive(:find).and_return(@sw_support_price)
  end

  it "should update the SwSupportPrice" do
    @sw_support_price.should_receive(:update_attributes)
    post :update, :id => @sw_support_price
  end

  context "when the update is successful" do
    before(:each) { @sw_support_price.stub!(:update_attributes).and_return(true) }

    it "should redirect to the index page" do
      post :update, :id => @sw_support_price
      response.should redirect_to(sw_support_prices_path)
    end

    it "should give a success message" do
      post :update, :id => @sw_support_price
      flash[:notice].should == "Price successfully updated"
    end

  end

  context "when the update fails" do
    before(:each) { @sw_support_price.stub!(:update_attributes).and_return(false) }

    it "should assign @sw_support_price for re-editing" do
      post :update, :id => @sw_support_price
      assigns[:sw_support_price].should == @sw_support_price
    end

    it "should render the edit page" do
      post :update, :id => @sw_support_price
      response.should render_template("edit")
    end

    it "should put a failure message" do
      post :update
    end

  end

end
describe SwSupportPricesController, "POST pull_pricing_helps" do
  before(:each) do
    controller.stub!(:login_required)
    @sw_support_price = mock_model(SwSupportPrice, :part_number => 'A6144A', :description => 'L3000', :list_price => 500.0, :phone_price => 400.0, :update_price => 100.0)
  end
  it "should succeed" do
    post :pull_pricing_helps, :part_number => 'A6144A'
    response.should be_success
  end

  it "should find current pricing for the current part number" do
    SwSupportPrice.stub(:current_list_price).and_return(@sw_support_price)
    post :pull_pricing_helps, :part_number => 'A6144A'
    assigns[:current_info].description.should contain('L3000')
    assigns[:current_info].phone_price.should == 400.0
    assigns[:current_info].list_price.should == 500.0
  end

  it "should search for a Sun product" do
    PricingDbSunService.should_receive(:find_pn)
    post :pull_pricing_helps
  end

  it "should find Sun pricing for the current part number" do
    sun_item = mock_model(PricingDbSunService, :list_price => 500.0, :description => 'sample description')
    PricingDbSunService.stub!(:find_pn).and_return(sun_item)
    post :pull_pricing_helps, :part_number => 'ASDF1234'
    assigns[:sun_info].list_price.should == 500.0
    assigns[:sun_info].description.should == "sample description"
  end

  it "should search for an HP product" do
    PricingDbHpPrice.should_receive(:find_sw_pn)
    post :pull_pricing_helps
  end

  it "should find HP pricing for the current part number" do
    hp_item = mock_model(PricingDbHpPrice, :list_price => 500.0, :description => 'sample description')
    PricingDbHpPrice.stub!(:find_sw_pn).and_return(hp_item)
    post :pull_pricing_helps, :part_number => 'ASDF1234'
    assigns[:hp_info].should == hp_item
  end

end

