require 'spec_helper'

describe ManufacturerLinesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/manufacturer_lines" }.should route_to(:controller => "manufacturer_lines", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/manufacturer_lines/new" }.should route_to(:controller => "manufacturer_lines", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/manufacturer_lines/1" }.should route_to(:controller => "manufacturer_lines", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/manufacturer_lines/1/edit" }.should route_to(:controller => "manufacturer_lines", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/manufacturer_lines" }.should route_to(:controller => "manufacturer_lines", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/manufacturer_lines/1" }.should route_to(:controller => "manufacturer_lines", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/manufacturer_lines/1" }.should route_to(:controller => "manufacturer_lines", :action => "destroy", :id => "1")
    end
  end
end
