require File.dirname(__FILE__) + '/../spec_helper'

describe DropdownsController, "#route_for" do

  it "should map { :controller => 'dropdowns', :action => 'index' } to /dropdowns" do
    route_for(:controller => "dropdowns", :action => "index").should == "/dropdowns"
  end
  
  it "should map { :controller => 'dropdowns', :action => 'new' } to /dropdowns/new" do
    route_for(:controller => "dropdowns", :action => "new").should == "/dropdowns/new"
  end
  
  it "should map { :controller => 'dropdowns', :action => 'show', :id => 1 } to /dropdowns/1" do
    route_for(:controller => "dropdowns", :action => "show", :id => 1).should == "/dropdowns/1"
  end
  
  it "should map { :controller => 'dropdowns', :action => 'edit', :id => 1 } to /dropdowns/1/edit" do
    route_for(:controller => "dropdowns", :action => "edit", :id => 1).should == "/dropdowns/1/edit"
  end
  
  it "should map { :controller => 'dropdowns', :action => 'update', :id => 1} to /dropdowns/1" do
    route_for(:controller => "dropdowns", :action => "update", :id => 1).should == "/dropdowns/1"
  end
  
  it "should map { :controller => 'dropdowns', :action => 'destroy', :id => 1} to /dropdowns/1" do
    route_for(:controller => "dropdowns", :action => "destroy", :id => 1).should == "/dropdowns/1"
  end
  
end

describe DropdownsController, "#params_from" do

  it "should generate params { :controller => 'dropdowns', action => 'index' } from GET /dropdowns" do
    params_from(:get, "/dropdowns").should == {:controller => "dropdowns", :action => "index"}
  end
  
  it "should generate params { :controller => 'dropdowns', action => 'new' } from GET /dropdowns/new" do
    params_from(:get, "/dropdowns/new").should == {:controller => "dropdowns", :action => "new"}
  end
  
  it "should generate params { :controller => 'dropdowns', action => 'create' } from POST /dropdowns" do
    params_from(:post, "/dropdowns").should == {:controller => "dropdowns", :action => "create"}
  end
  
  it "should generate params { :controller => 'dropdowns', action => 'show', id => '1' } from GET /dropdowns/1" do
    params_from(:get, "/dropdowns/1").should == {:controller => "dropdowns", :action => "show", :id => "1"}
  end
  
  it "should generate params { :controller => 'dropdowns', action => 'edit', id => '1' } from GET /dropdowns/1;edit" do
    params_from(:get, "/dropdowns/1/edit").should == {:controller => "dropdowns", :action => "edit", :id => "1"}
  end
  
  it "should generate params { :controller => 'dropdowns', action => 'update', id => '1' } from PUT /dropdowns/1" do
    params_from(:put, "/dropdowns/1").should == {:controller => "dropdowns", :action => "update", :id => "1"}
  end
  
  it "should generate params { :controller => 'dropdowns', action => 'destroy', id => '1' } from DELETE /dropdowns/1" do
    params_from(:delete, "/dropdowns/1").should == {:controller => "dropdowns", :action => "destroy", :id => "1"}
  end
  
end

describe DropdownsController, "handling GET /dropdowns" do

  before do
    @dropdowns = mock_model(Dropdown)
    Dropdown.stub!(:find).and_return([@dropdowns])
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
  
  it "should find all dropdowns" do
    Dropdown.should_receive(:find).with(:all, :order => "dd_name, filter, sort_order").and_return([@dropdowns])
    do_get
  end
  
  it "should assign the found dropdowns for the view" do
    do_get
    assigns[:dropdowns].should == [@dropdowns]
  end
end

describe DropdownsController, "handling GET /dropdowns.xml" do

  before do
    @dropdowns = mock_model(Dropdown, :to_xml => "XML")
    Dropdown.stub!(:find).and_return(@dropdowns)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all dropdowns" do
    Dropdown.should_receive(:find).with(:all, :order => "dd_name, filter, sort_order").and_return([@dropdowns])
    do_get
  end
  
  it "should render the found dropdowns as xml" do
    @dropdowns.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe DropdownsController, "handling GET /dropdowns/1" do

  before do
    @dropdowns = mock_model(Dropdown)
    Dropdown.stub!(:find).and_return(@dropdowns)
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
  
  it "should find the dropdowns requested" do
    Dropdown.should_receive(:find).with("1").and_return(@dropdowns)
    do_get
  end
  
  it "should assign the found dropdowns for the view" do
    do_get
    assigns[:dropdowns].should equal(@dropdowns)
  end
end

describe DropdownsController, "handling GET /dropdowns/1.xml" do

  before do
    @dropdowns = mock_model(Dropdown, :to_xml => "XML")
    Dropdown.stub!(:find).and_return(@dropdowns)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the dropdowns requested" do
    Dropdown.should_receive(:find).with("1").and_return(@dropdowns)
    do_get
  end
  
  it "should render the found dropdowns as xml" do
    @dropdowns.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe DropdownsController, "handling GET /dropdowns/new" do

  before do
    @dropdowns = mock_model(Dropdown)
    Dropdown.stub!(:new).and_return(@dropdowns)
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
  
  it "should create an new dropdowns" do
    Dropdown.should_receive(:new).and_return(@dropdowns)
    do_get
  end
  
  it "should not save the new dropdowns" do
    @dropdowns.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new dropdowns for the view" do
    do_get
    assigns[:dropdowns].should equal(@dropdowns)
  end
end

describe DropdownsController, "handling GET /dropdowns/1/edit" do

  before do
    @dropdowns = mock_model(Dropdown)
    Dropdown.stub!(:find).and_return(@dropdowns)
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
  
  it "should find the dropdowns requested" do
    Dropdown.should_receive(:find).and_return(@dropdowns)
    do_get
  end
  
  it "should assign the found Dropdowns for the view" do
    do_get
    assigns[:dropdowns].should equal(@dropdowns)
  end
end

describe DropdownsController, "handling POST /dropdowns" do

  before do
    @dropdown = mock_model(Dropdown, :to_param => "1")
    Dropdown.stub!(:new).and_return(@dropdown)
  end
  
  def post_with_successful_save
    @dropdown.should_receive(:save).and_return(true)
    post :create, :dropdown => {}
  end
  
  def post_with_failed_save
    @dropdown.should_receive(:save).and_return(false)
    post :create, :dropdown => {}
  end
  
  it "should create a new dropdowns" do
    Dropdown.should_receive(:new).with({}).and_return(@dropdown)
    post_with_successful_save
  end

  it "should redirect to the new dropdowns on successful save" do
    post_with_successful_save
    response.should redirect_to(dropdown_url("1"))
  end

  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end
end

describe DropdownsController, "handling PUT /dropdowns/1" do

  before do
    @dropdowns = mock_model(Dropdown, :to_param => "1")
    Dropdown.stub!(:find).and_return(@dropdowns)
  end
  
  def put_with_successful_update
    @dropdowns.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_failed_update
    @dropdowns.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1"
  end
  
  it "should find the dropdowns requested" do
    Dropdown.should_receive(:find).with("1").and_return(@dropdowns)
    put_with_successful_update
  end

  it "should update the found dropdowns" do
    put_with_successful_update
    assigns(:dropdowns).should equal(@dropdowns)
  end

  it "should assign the found dropdowns for the view" do
    put_with_successful_update
    assigns(:dropdowns).should equal(@dropdowns)
  end

  it "should redirect to the dropdowns on successful update" do
    put_with_successful_update
    response.should redirect_to(dropdown_url("1"))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe DropdownsController, "handling DELETE /dropdowns/1" do

  before do
    @dropdown = mock_model(Dropdown, :destroy => true)
    @dropdown.stub!(:id).and_return("1")
    Dropdown.stub!(:find).and_return(@dropdown)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the dropdowns requested" do
    Dropdown.should_receive(:find).with("1").and_return(@dropdown)
    do_delete
  end
  
  it "should call destroy on the found dropdowns" do
    @dropdown.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the dropdowns list" do
    do_delete
    response.should redirect_to(dropdowns_url)
  end
end
