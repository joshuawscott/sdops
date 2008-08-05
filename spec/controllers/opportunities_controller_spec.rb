require File.dirname(__FILE__) + '/../spec_helper'

describe OpportunitiesController do
  describe "handling GET /opportunities" do

    before(:each) do
      @sugar_opp = mock_model(SugarOpp)
      @opportunity = mock_model(Opportunity)
      @sugar_opp.stub!(:opportuinty).and_return(@opportunity)
      SugarOpp.stub!(:find).and_return([@sugar_opp])
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
  
    it "should find all opportunities" do
      SugarOpp.should_receive(:find).and_return([@sugar_opp])
      do_get
    end
  
    it "should assign the found opportunities for the view" do
      do_get
      assigns[:opportunities].should == [@sugar_opp]
    end
  end

  #describe "handling GET /opportunities.xml" do
  #
  #  before(:each) do
  #    @opportunities = mock("Array of Opportunities", :to_xml => "XML")
  #    Opportunity.stub!(:find).and_return(@opportunities)
  #  end
  #
  #  def do_get
  #    @request.env["HTTP_ACCEPT"] = "application/xml"
  #    get :index
  #  end
  #
  #  it "should be successful" do
  #    do_get
  #    response.should be_success
  #  end
  #
  #  it "should find all opportunities" do
  #    Opportunity.should_receive(:find).with(:all).and_return(@opportunities)
  #    do_get
  #  end
  #
  #  it "should render the found opportunities as xml" do
  #    @opportunities.should_receive(:to_xml).and_return("XML")
  #    do_get
  #    response.body.should == "XML"
  #  end
  #end

  describe "handling GET /opportunities/1" do

    before(:each) do
      @sugar_opp = mock_model(SugarOpp)
      @opportunity = mock_model(Opportunity)
      @sugar_opp.stub!(:opportuinty).and_return(@opportunity)
      SugarOpp.stub!(:find).and_return([@sugar_opp])
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
  
    it "should find the opportunity requested" do
      SugarOpp.should_receive(:find).and_return(@sugar_opp)
      do_get
    end
  
    it "should assign the found opportunity for the view" do
      do_get
      assigns[:opportunity].should == [@sugar_opp]
    end
  end

  #describe "handling GET /opportunities/1.xml" do
  #
  #  before(:each) do
  #    @opportunity = mock_model(Opportunity, :to_xml => "XML")
  #    Opportunity.stub!(:find).and_return(@opportunity)
  #  end
  #
  #  def do_get
  #    @request.env["HTTP_ACCEPT"] = "application/xml"
  #    get :show, :id => "1"
  #  end
  #
  #  it "should be successful" do
  #    do_get
  #    response.should be_success
  #  end
  #
  #  it "should find the opportunity requested" do
  #    Opportunity.should_receive(:find).with("1").and_return(@opportunity)
  #    do_get
  #  end
  #
  #  it "should render the found opportunity as xml" do
  #    @opportunity.should_receive(:to_xml).and_return("XML")
  #    do_get
  #    response.body.should == "XML"
  #  end
  #end

  describe "handling GET /opportunities/new" do

    before(:each) do
      @opportunity = mock_model(Opportunity)
      Opportunity.stub!(:new).and_return(@opportunity)
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
  
    it "should create an new opportunity" do
      Opportunity.should_receive(:new).and_return(@opportunity)
      do_get
    end
  
    it "should not save the new opportunity" do
      @opportunity.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new opportunity for the view" do
      do_get
      assigns[:opportunity].should equal(@opportunity)
    end
  end

  describe "handling GET /opportunities/1/edit" do

    before(:each) do
      @opportunity = mock_model(Opportunity)
      Opportunity.stub!(:find).and_return(@opportunity)
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
  
    it "should find the opportunity requested" do
      Opportunity.should_receive(:find).and_return(@opportunity)
      do_get
    end
  
    it "should assign the found Opportunity for the view" do
      do_get
      assigns[:opportunity].should equal(@opportunity)
    end
  end

  describe "handling POST /opportunities" do

    before(:each) do
      @opportunity = mock_model(Opportunity, :to_param => "1")
      Opportunity.stub!(:new).and_return(@opportunity)
    end
    
    describe "with successful save" do
  
      def do_post
        @opportunity.should_receive(:save).and_return(true)
        post :create, :opportunity => {}
      end
  
      it "should create a new opportunity" do
        Opportunity.should_receive(:new).with({}).and_return(@opportunity)
        do_post
      end

      it "should redirect to the new opportunity" do
        do_post
        response.should redirect_to(opportunity_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @opportunity.should_receive(:save).and_return(false)
        post :create, :opportunity => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /opportunities/1" do

    before(:each) do
      @opportunity = mock_model(Opportunity, :to_param => "1")
      Opportunity.stub!(:find).and_return(@opportunity)
    end
    
    describe "with successful update" do

      def do_put
        @opportunity.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the opportunity requested" do
        Opportunity.should_receive(:find).with("1").and_return(@opportunity)
        do_put
      end

      it "should update the found opportunity" do
        do_put
        assigns(:opportunity).should equal(@opportunity)
      end

      it "should assign the found opportunity for the view" do
        do_put
        assigns(:opportunity).should equal(@opportunity)
      end

      it "should redirect to the opportunity" do
        do_put
        response.should redirect_to(opportunity_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @opportunity.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /opportunities/1" do

    before(:each) do
      @opportunity = mock_model(Opportunity, :destroy => true)
      Opportunity.stub!(:find).and_return(@opportunity)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the opportunity requested" do
      Opportunity.should_receive(:find).with("1").and_return(@opportunity)
      do_delete
    end
  
    it "should call destroy on the found opportunity" do
      @opportunity.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the opportunities list" do
      do_delete
      response.should redirect_to(opportunities_url)
    end
  end
end