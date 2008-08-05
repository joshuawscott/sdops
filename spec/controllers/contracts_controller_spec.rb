require File.dirname(__FILE__) + '/../spec_helper'

describe ContractsController, "#route_for" do

  it "should map { :controller => 'contracts', :action => 'index' } to /contracts" do
    route_for(:controller => "contracts", :action => "index").should == "/contracts"
  end
  
  it "should map { :controller => 'contracts', :action => 'new' } to /contracts/new" do
    route_for(:controller => "contracts", :action => "new").should == "/contracts/new"
  end
  
  it "should map { :controller => 'contracts', :action => 'show', :id => 1 } to /contracts/1" do
    route_for(:controller => "contracts", :action => "show", :id => 1).should == "/contracts/1"
  end
  
  it "should map { :controller => 'contracts', :action => 'edit', :id => 1 } to /contracts/1/edit" do
    route_for(:controller => "contracts", :action => "edit", :id => 1).should == "/contracts/1/edit"
  end
  
  it "should map { :controller => 'contracts', :action => 'update', :id => 1} to /contracts/1" do
    route_for(:controller => "contracts", :action => "update", :id => 1).should == "/contracts/1"
  end
  
  it "should map { :controller => 'contracts', :action => 'destroy', :id => 1} to /contracts/1" do
    route_for(:controller => "contracts", :action => "destroy", :id => 1).should == "/contracts/1"
  end
  
end

describe ContractsController, "handling GET /contracts" do

  before do
    @contract = mock_model(Contract)
    Contract.stub!(:find).and_return([@contract])
  end
  
  def do_get
    login_as(:admin)
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
  
  it "should find all contracts" do
    Contract.should_receive(:short_list).and_return([@contract])
    do_get
  end
  
  it "should assign the found contracts for the view" do
    do_get
    assigns[:contracts].should == [@contract]
  end
end

describe ContractsController, "handling GET /contracts.xml" do
  
  before do
    @contract = mock_model(Contract, :to_xml => "XML")
    @contract.stub!(:id).and_return("1")
    @line_item = mock_model(LineItem)
    @contract.stub!(:line_items).and_return([@line_item])
    Contract.stub!(:find).and_return(@contract)
  end
  
  def do_get
    login_as(:admin)
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all contracts" do
    Contract.should_receive(:short_list).and_return([@contract])
    do_get
  end
  
  it "should render the found contracts as xml" do
    @contract.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe ContractsController, "handling GET /contracts/1" do

  before do
    @contract = mock_model(Contract)
    @contract.stub!(:id).and_return("1")
    @line_item = mock_model(LineItem)
    @contract.stub!(:line_items).and_return([@line_item])
    Contract.stub!(:find).and_return(@contract)
  end
  
  def do_get
    login_as(:admin)
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
  
  it "should find the contract requested" do
    Contract.should_receive(:find).with("1").and_return(@contract)
    do_get
  end
  
  it "should assign the found contract for the view" do
    do_get
    assigns[:contract].should equal(@contract)
  end
end

describe ContractsController, "handling GET /contracts/1.xml" do

  before do
    @contract = mock_model(Contract, :to_xml => "XML")
    @contract.stub!(:id).and_return("1")
    @line_item = mock_model(LineItem)
    @contract.stub!(:line_items).and_return([@line_item])
    Contract.stub!(:find).and_return(@contract)
  end
  
  def do_get
    login_as(:admin)
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the contract requested" do
    Contract.should_receive(:find).with("1").and_return(@contract)
    do_get
  end
  
  it "should render the found contract as xml" do
    @contract.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe ContractsController, "handling GET /contracts/new" do

  before do
    @contract = mock_model(Contract)
    Contract.stub!(:new).and_return(@contract)
  end
  
  def do_get
    login_as(:admin)
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
  
  it "should create an new contract" do
    Contract.should_receive(:new).and_return(@contract)
    do_get
  end
  
  it "should not save the new contract" do
    @contract.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new contract for the view" do
    do_get
    assigns[:contract].should equal(@contract)
  end
end

describe ContractsController, "handling GET /contracts/1/edit" do

  before do
    @contract = mock_model(Contract)
    Contract.stub!(:find).and_return(@contract)
  end
  
  def do_get
    login_as(:admin)
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
  
  it "should find the contract requested" do
    Contract.should_receive(:find).and_return(@contract)
    do_get
  end
  
  it "should assign the found Contract for the view" do
    do_get
    assigns[:contract].should equal(@contract)
  end
end

describe ContractsController, "handling POST /contracts" do

  before do
    @contract = mock_model(Contract, :to_param => "1")
    Contract.stub!(:new).and_return(@contract)
  end
  
  def post_with_successful_save
    login_as(:admin)
    @contract.should_receive(:save).and_return(true)
    post :create, :contract => {}
  end
  
  def post_with_failed_save
    login_as(:admin)
    @contract.should_receive(:save).and_return(false)
    post :create, :contract => {}
  end
  
  it "should create a new contract" do
    Contract.should_receive(:new).with({}).and_return(@contract)
    post_with_successful_save
  end

  it "should redirect to the new contract on successful save" do
    post_with_successful_save
    response.should redirect_to(contract_url("1"))
  end

  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end
end

describe ContractsController, "handling PUT /contracts/1" do

  before do
    @contract = mock_model(Contract, :to_param => "1")
    Contract.stub!(:find).and_return(@contract)
  end
  
  def put_with_successful_update
    login_as(:admin)
    @contract.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_failed_update
    login_as(:admin)
    @contract.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1"
  end
  
  it "should find the contract requested" do
    Contract.should_receive(:find).with("1").and_return(@contract)
    put_with_successful_update
  end

  it "should update the found contract" do
    put_with_successful_update
    assigns(:contract).should equal(@contract)
  end

  it "should assign the found contract for the view" do
    put_with_successful_update
    assigns(:contract).should equal(@contract)
  end

  it "should redirect to the contract on successful update" do
    put_with_successful_update
    response.should redirect_to(contract_url("1"))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe ContractsController, "handling DELETE /contracts/1" do

  before do
    @contract = mock_model(Contract, :destroy => true)
    Contract.stub!(:find).and_return(@contract)

  end

  def do_delete
    login_as(:admin)
    delete :destroy, :id => "1"
  end

  it "should find the contract requested" do
    Contract.should_receive(:find).with("1").and_return(@contract)
    do_delete
  end
  
  it "should call destroy on the found contract" do
    @contract.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the contracts list" do
    do_delete
    response.should redirect_to(contracts_url)
  end
end
