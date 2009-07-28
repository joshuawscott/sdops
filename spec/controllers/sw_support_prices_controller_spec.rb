require File.dirname(__FILE__) + '/../spec_helper'

describe SwSupportPricesController do

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
      SwSupportPrice.should_receive(:search).with('A6144', '', Time.now.to_date)
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
