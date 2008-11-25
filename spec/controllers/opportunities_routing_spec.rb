require File.dirname(__FILE__) + '/../spec_helper'

describe OpportunitiesController do
  describe "route generation" do

    it "should map { :controller => 'opportunities', :action => 'index' } to /opportunities" do
      route_for(:controller => "opportunities", :action => "index").should == "/opportunities"
    end
  
    it "should map { :controller => 'opportunities', :action => 'new' } to /opportunities/new" do
      route_for(:controller => "opportunities", :action => "new").should == "/opportunities/new"
    end
  
    it "should map { :controller => 'opportunities', :action => 'show', :id => 1 } to /opportunities/1" do
      route_for(:controller => "opportunities", :action => "show", :id => 1).should == "/opportunities/1"
    end
  
    it "should map { :controller => 'opportunities', :action => 'edit', :id => 1 } to /opportunities/1/edit" do
      route_for(:controller => "opportunities", :action => "edit", :id => 1).should == "/opportunities/1/edit"
    end
  
    it "should map { :controller => 'opportunities', :action => 'update', :id => 1} to /opportunities/1" do
      route_for(:controller => "opportunities", :action => "update", :id => 1).should == "/opportunities/1"
    end
  
    it "should map { :controller => 'opportunities', :action => 'destroy', :id => 1} to /opportunities/1" do
      route_for(:controller => "opportunities", :action => "destroy", :id => 1).should == "/opportunities/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'opportunities', action => 'index' } from GET /opportunities" do
      params_from(:get, "/opportunities").should == {:controller => "opportunities", :action => "index"}
    end
  
    it "should generate params { :controller => 'opportunities', action => 'new' } from GET /opportunities/new" do
      params_from(:get, "/opportunities/new").should == {:controller => "opportunities", :action => "new"}
    end
  
    it "should generate params { :controller => 'opportunities', action => 'create' } from POST /opportunities" do
      params_from(:post, "/opportunities").should == {:controller => "opportunities", :action => "create"}
    end
  
    it "should generate params { :controller => 'opportunities', action => 'show', id => '1' } from GET /opportunities/1" do
      params_from(:get, "/opportunities/1").should == {:controller => "opportunities", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'opportunities', action => 'edit', id => '1' } from GET /opportunities/1;edit" do
      params_from(:get, "/opportunities/1/edit").should == {:controller => "opportunities", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'opportunities', action => 'update', id => '1' } from PUT /opportunities/1" do
      params_from(:put, "/opportunities/1").should == {:controller => "opportunities", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'opportunities', action => 'destroy', id => '1' } from DELETE /opportunities/1" do
      params_from(:delete, "/opportunities/1").should == {:controller => "opportunities", :action => "destroy", :id => "1"}
    end
  end
end