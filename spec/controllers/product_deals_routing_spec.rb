require File.dirname(__FILE__) + '/../spec_helper'

describe ProductDealsController do
  describe "route generation" do

    it "should map { :controller => 'product_deals', :action => 'index' } to /product_deals" do
      route_for(:controller => "product_deals", :action => "index").should == "/product_deals"
    end
  
    it "should map { :controller => 'product_deals', :action => 'new' } to /product_deals/new" do
      route_for(:controller => "product_deals", :action => "new").should == "/product_deals/new"
    end
  
    it "should map { :controller => 'product_deals', :action => 'show', :id => 1 } to /product_deals/1" do
      route_for(:controller => "product_deals", :action => "show", :id => 1).should == "/product_deals/1"
    end
  
    it "should map { :controller => 'product_deals', :action => 'edit', :id => 1 } to /product_deals/1/edit" do
      route_for(:controller => "product_deals", :action => "edit", :id => 1).should == "/product_deals/1/edit"
    end
  
    it "should map { :controller => 'product_deals', :action => 'update', :id => 1} to /product_deals/1" do
      route_for(:controller => "product_deals", :action => "update", :id => 1).should == "/product_deals/1"
    end
  
    it "should map { :controller => 'product_deals', :action => 'destroy', :id => 1} to /product_deals/1" do
      route_for(:controller => "product_deals", :action => "destroy", :id => 1).should == "/product_deals/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'product_deals', action => 'index' } from GET /product_deals" do
      params_from(:get, "/product_deals").should == {:controller => "product_deals", :action => "index"}
    end
  
    it "should generate params { :controller => 'product_deals', action => 'new' } from GET /product_deals/new" do
      params_from(:get, "/product_deals/new").should == {:controller => "product_deals", :action => "new"}
    end
  
    it "should generate params { :controller => 'product_deals', action => 'create' } from POST /product_deals" do
      params_from(:post, "/product_deals").should == {:controller => "product_deals", :action => "create"}
    end
  
    it "should generate params { :controller => 'product_deals', action => 'show', id => '1' } from GET /product_deals/1" do
      params_from(:get, "/product_deals/1").should == {:controller => "product_deals", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'product_deals', action => 'edit', id => '1' } from GET /product_deals/1;edit" do
      params_from(:get, "/product_deals/1/edit").should == {:controller => "product_deals", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'product_deals', action => 'update', id => '1' } from PUT /product_deals/1" do
      params_from(:put, "/product_deals/1").should == {:controller => "product_deals", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'product_deals', action => 'destroy', id => '1' } from DELETE /product_deals/1" do
      params_from(:delete, "/product_deals/1").should == {:controller => "product_deals", :action => "destroy", :id => "1"}
    end
  end
end