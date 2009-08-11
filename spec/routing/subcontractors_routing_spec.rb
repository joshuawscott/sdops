require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubcontractorsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "subcontractors", :action => "index").should == "/subcontractors"
    end

    it "maps #new" do
      route_for(:controller => "subcontractors", :action => "new").should == "/subcontractors/new"
    end

    it "maps #show" do
      route_for(:controller => "subcontractors", :action => "show", :id => "1").should == "/subcontractors/1"
    end

    it "maps #edit" do
      route_for(:controller => "subcontractors", :action => "edit", :id => "1").should == "/subcontractors/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "subcontractors", :action => "create").should == {:path => "/subcontractors", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "subcontractors", :action => "update", :id => "1").should == {:path =>"/subcontractors/1", :method => :put}
  end

    it "maps #destroy" do
      route_for(:controller => "subcontractors", :action => "destroy", :id => "1").should == {:path =>"/subcontractors/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/subcontractors").should == {:controller => "subcontractors", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/subcontractors/new").should == {:controller => "subcontractors", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/subcontractors").should == {:controller => "subcontractors", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/subcontractors/1").should == {:controller => "subcontractors", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/subcontractors/1/edit").should == {:controller => "subcontractors", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/subcontractors/1").should == {:controller => "subcontractors", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/subcontractors/1").should == {:controller => "subcontractors", :action => "destroy", :id => "1"}
    end
  end
end
