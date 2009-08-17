require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubcontractsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "subcontracts", :action => "index").should == "/subcontracts"
    end
  
    it "maps #new" do
      route_for(:controller => "subcontracts", :action => "new").should == "/subcontracts/new"
    end
  
    it "maps #show" do
      route_for(:controller => "subcontracts", :action => "show", :id => "1").should == "/subcontracts/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "subcontracts", :action => "edit", :id => "1").should == "/subcontracts/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "subcontracts", :action => "create").should == {:path => "/subcontracts", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "subcontracts", :action => "update", :id => "1").should == {:path =>"/subcontracts/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "subcontracts", :action => "destroy", :id => "1").should == {:path =>"/subcontracts/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/subcontracts").should == {:controller => "subcontracts", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/subcontracts/new").should == {:controller => "subcontracts", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/subcontracts").should == {:controller => "subcontracts", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/subcontracts/1").should == {:controller => "subcontracts", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/subcontracts/1/edit").should == {:controller => "subcontracts", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/subcontracts/1").should == {:controller => "subcontracts", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/subcontracts/1").should == {:controller => "subcontracts", :action => "destroy", :id => "1"}
    end
  end
end
