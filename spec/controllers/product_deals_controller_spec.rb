require File.dirname(__FILE__) + '/../spec_helper'

describe ProductDealsController do
  describe "handling GET /product_deals" do

    before(:each) do
      @product_deal = mock_model(ProductDeal)
      ProductDeal.stub!(:find).and_return([@product_deal])
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should find all product_deals" do
      ProductDeal.should_receive(:find).with(:all).and_return([@product_deal])
      do_get
    end
  
    it "should assign the found product_deals for the view" do
      do_get
      assigns[:product_deals].should == [@product_deal]
    end
  end

  describe "handling GET /product_deals.xml" do

    before(:each) do
      @product_deals = mock("Array of ProductDeals", :to_xml => "XML")
      ProductDeal.stub!(:find).and_return(@product_deals)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all product_deals" do
      ProductDeal.should_receive(:find).with(:all).and_return(@product_deals)
      do_get
    end
  
    it "should render the found product_deals as xml" do
      @product_deals.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /product_deals/1" do

    before(:each) do
      @product_deal = mock_model(ProductDeal)
      ProductDeal.stub!(:find).and_return(@product_deal)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the product_deal requested" do
      ProductDeal.should_receive(:find).with("1").and_return(@product_deal)
      do_get
    end
  
    it "should assign the found product_deal for the view" do
      do_get
      assigns[:product_deal].should equal(@product_deal)
    end
  end

  describe "handling GET /product_deals/1.xml" do

    before(:each) do
      @product_deal = mock_model(ProductDeal, :to_xml => "XML")
      ProductDeal.stub!(:find).and_return(@product_deal)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the product_deal requested" do
      ProductDeal.should_receive(:find).with("1").and_return(@product_deal)
      do_get
    end
  
    it "should render the found product_deal as xml" do
      @product_deal.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /product_deals/new" do

    before(:each) do
      @product_deal = mock_model(ProductDeal)
      ProductDeal.stub!(:new).and_return(@product_deal)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new product_deal" do
      ProductDeal.should_receive(:new).and_return(@product_deal)
      do_get
    end
  
    it "should not save the new product_deal" do
      @product_deal.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new product_deal for the view" do
      do_get
      assigns[:product_deal].should equal(@product_deal)
    end
  end

  describe "handling GET /product_deals/1/edit" do

    before(:each) do
      @product_deal = mock_model(ProductDeal)
      ProductDeal.stub!(:find).and_return(@product_deal)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the product_deal requested" do
      ProductDeal.should_receive(:find).and_return(@product_deal)
      do_get
    end
  
    it "should assign the found ProductDeal for the view" do
      do_get
      assigns[:product_deal].should equal(@product_deal)
    end
  end

  describe "handling POST /product_deals" do

    before(:each) do
      @product_deal = mock_model(ProductDeal, :to_param => "1")
      ProductDeal.stub!(:new).and_return(@product_deal)
    end
    
    describe "with successful save" do
  
      def do_post
        @product_deal.should_receive(:save).and_return(true)
        post :create, :product_deal => {}
      end
  
      it "should create a new product_deal" do
        ProductDeal.should_receive(:new).with({}).and_return(@product_deal)
        do_post
      end

      it "should redirect to the new product_deal" do
        do_post
        response.should redirect_to(product_deal_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @product_deal.should_receive(:save).and_return(false)
        post :create, :product_deal => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /product_deals/1" do

    before(:each) do
      @product_deal = mock_model(ProductDeal, :to_param => "1")
      ProductDeal.stub!(:find).and_return(@product_deal)
    end
    
    describe "with successful update" do

      def do_put
        @product_deal.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the product_deal requested" do
        ProductDeal.should_receive(:find).with("1").and_return(@product_deal)
        do_put
      end

      it "should update the found product_deal" do
        do_put
        assigns(:product_deal).should equal(@product_deal)
      end

      it "should assign the found product_deal for the view" do
        do_put
        assigns(:product_deal).should equal(@product_deal)
      end

      it "should redirect to the product_deal" do
        do_put
        response.should redirect_to(product_deal_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @product_deal.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /product_deals/1" do

    before(:each) do
      @product_deal = mock_model(ProductDeal, :destroy => true)
      ProductDeal.stub!(:find).and_return(@product_deal)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the product_deal requested" do
      ProductDeal.should_receive(:find).with("1").and_return(@product_deal)
      do_delete
    end
  
    it "should call destroy on the found product_deal" do
      @product_deal.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the product_deals list" do
      do_delete
      response.should redirect_to(product_deals_url)
    end
  end
end