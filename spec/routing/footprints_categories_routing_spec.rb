require 'spec_helper'

describe FootprintsCategoriesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/footprints_categories" }.should route_to(:controller => "footprints_categories", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/footprints_categories/new" }.should route_to(:controller => "footprints_categories", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/footprints_categories/1" }.should route_to(:controller => "footprints_categories", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/footprints_categories/1/edit" }.should route_to(:controller => "footprints_categories", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/footprints_categories" }.should route_to(:controller => "footprints_categories", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/footprints_categories/1" }.should route_to(:controller => "footprints_categories", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/footprints_categories/1" }.should route_to(:controller => "footprints_categories", :action => "destroy", :id => "1")
    end
  end
end
