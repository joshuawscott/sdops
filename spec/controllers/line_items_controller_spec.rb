#require 'ruby-debug'
require File.dirname(__FILE__) + '/../spec_helper'

describe LineItemsController, "#route_for" do

  it "should map { :controller => 'line_items', :action => 'index' } to /contracts/:id/line_items" do
    route_for(:controller => "line_items", :action => "index", :contract_id => 2).should == "/contracts/2/line_items"
  end
  
  it "should map { :controller => 'line_items', :action => 'new' } to /contracts/:id/line_items/new" do
    route_for(:controller => "line_items", :action => "new", :contract_id => 2).should == "/contracts/2/line_items/new"
  end
  
  it "should map { :controller => 'line_items', :action => 'show', :id => 1 } to /contracts/:id/line_items/1" do
    route_for(:controller => "line_items", :action => "show", :id => 1, :contract_id => 2).should == "/contracts/2/line_items/1"
  end
  
  it "should map { :controller => 'line_items', :action => 'edit', :id => 1 } to /contracts/:id/line_items/1/edit" do
    route_for(:controller => "line_items", :action => "edit", :id => 1, :contract_id => 2).should == "/contracts/2/line_items/1/edit"
  end
  
  it "should map { :controller => 'line_items', :action => 'update', :id => 1} to /contracts/:id/line_items/1" do
    route_for(:controller => "line_items", :action => "update", :id => 1, :contract_id => 2).should == "/contracts/2/line_items/1"
  end
  
  it "should map { :controller => 'line_items', :action => 'destroy', :id => 1} to /contracts/:id/line_items/1" do
    route_for(:controller => "line_items", :action => "destroy", :id => 1, :contract_id => 2).should == "/contracts/2/line_items/1"
  end

end
=begin
describe LineItemsController, "handling GET /line_items/1.xml" do
  
  before do
    @line_item = mock_model(LineItem, :to_xml => "XML")

    @contract = mock_model(Contract)
    @contract.stub!(:line_items).and_return(@line_item)
    @contract.line_items.should_receive(:find).with("1").and_return(@line_item)
    Contract.stub!(:find).and_return(@contract)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the line_item requested" do
    LineItem.should_receive(:find).with("1").and_return(@line_item)
    do_get
  end
  
  it "should render the found line_item as xml" do
    @line_item.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end

end
=end

describe LineItemsController, "handling GET /contracts/1/line_items/new" do

  before do
    @line_item = mock_model(LineItem)

    @contract = mock_model(Contract)
    Contract.stub!(:find).and_return(@contract)
    @contract.stub!(:line_items).and_return(@line_item)
    @contract.line_items.stub!(:new).and_return(@line_item)

  end
  
  def do_get
    get :new, :contract_id => @contract.id
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new line_item" do
    @contract.line_items.should_receive(:new).and_return(@line_item)
    do_get
  end
  
  it "should not save the new line_item" do
    @line_item.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new line_item for the view" do
    do_get
    assigns[:line_item].should equal(@line_item)
  end
end

describe LineItemsController, "handling GET /line_items/1/edit" do

  before do
    @line_item = mock_model(LineItem)
    @line_item.stub!(:id).and_return("1")

    @contract = mock_model(Contract)
    Contract.stub!(:find).and_return(@contract)
    @contract.stub!(:line_items).and_return(@line_item)
    @contract.line_items.should_receive(:find).with("1").and_return(@line_item)
    
  end
  
  def do_get
    get :edit, :id => "1", :contract_id => @contract.id
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the line_item requested" do
    do_get
  end
  
  it "should assign the found LineItem for the view" do
    do_get
    assigns[:line_item].should equal(@line_item)
  end
end

describe LineItemsController, "handling POST /line_items" do

  before do
    @contract = mock_model(Contract)
    @line_item = mock_model(LineItem, :to_param => "1")
    @line_item.stub!(:contract_id=).and_return(@contract.id)

    @contract.stub!(:line_items).and_return(@line_item)
    @contract.line_items.stub!(:new).and_return(@line_item)
    Contract.stub!(:find).and_return(@contract)
  end
  
  def post_with_successful_save
    @line_item.should_receive(:save).and_return(true)
    post :create, :line_item => {}, :contract_id => @contract.id
  end
  
  def post_with_failed_save
    @line_item.should_receive(:save).and_return(false)
    post :create, :line_item => {}, :contract_id => @contract.id
  end
  
  it "should create a new line_item" do
    @contract.line_items.should_receive(:new).and_return(@line_item)
    post_with_successful_save
  end

  it "should redirect to the new line_item on successful save" do
    post_with_successful_save
    response.should redirect_to(contract_url(@contract.id))
  end

  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end

end

describe LineItemsController, "handling PUT /line_items/1" do

  before do
    @line_item = mock_model(LineItem, :to_param => "1")

    @contract = mock_model(Contract)
    @contract.stub!(:line_items).and_return(@line_item)
    @contract.line_items.should_receive(:find).with("1").and_return(@line_item)
    Contract.stub!(:find).and_return(@contract)
  end
  
  def put_with_successful_update
    @line_item.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1", :contract_id => @contract.id
  end
  
  def put_with_failed_update
    @line_item.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1", :contract_id => @contract.id
  end
  
  it "should find the line_item requested" do
    put_with_successful_update
  end

  it "should update the found line_item" do
    put_with_successful_update
    assigns(:line_item).should equal(@line_item)
  end

  it "should assign the found line_item for the view" do
    put_with_successful_update
    assigns(:line_item).should equal(@line_item)
  end

  it "should redirect to the line_item on successful update" do
    put_with_successful_update
    response.should redirect_to(contract_url(@contract.id))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe LineItemsController, "handling DELETE /line_items/1" do

  before do
    @line_item = mock_model(LineItem, :destroy => true)
    @line_item.stub!(:id).and_return("1")

    @contract = mock_model(Contract)
    @contract.stub!(:line_items).and_return(@line_item)
    @contract.line_items.should_receive(:find).with("1").and_return(@line_item)
    Contract.stub!(:find).and_return(@contract)
  end
  
  def do_delete
     delete :destroy, :id => "1", :contract_id => @contract.id
  end

  it "should find the line_item requested" do
    do_delete
  end
  
  it "should call destroy on the found line_item" do
    @line_item.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the line_items list" do
    do_delete
    response.should redirect_to(contract_url(@contract.id))
  end
end

