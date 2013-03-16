require 'spec_helper'

describe FootprintsCategoriesController do

  before(:each) do
    controller.stub!(:login_required)
  end

  def mock_footprints_category(stubs={})
    @mock_footprints_category ||= mock_model(FootprintsCategory, stubs)
  end

  describe "GET index" do
    it "assigns all footprints_categories as @footprints_categories" do
      FootprintsCategory.stub!(:find).with(:all).and_return([mock_footprints_category])
      get :index
      assigns[:footprints_categories].should == [mock_footprints_category]
    end
  end

  describe "GET show" do
    it "assigns the requested footprints_category as @footprints_category" do
      FootprintsCategory.stub!(:find).with("37").and_return(mock_footprints_category)
      get :show, :id => "37"
      assigns[:footprints_category].should equal(mock_footprints_category)
    end
  end

  describe "GET new" do
    it "assigns a new footprints_category as @footprints_category" do
      FootprintsCategory.stub!(:new).and_return(mock_footprints_category)
      get :new
      assigns[:footprints_category].should equal(mock_footprints_category)
    end
  end

  describe "GET edit" do
    it "assigns the requested footprints_category as @footprints_category" do
      FootprintsCategory.stub!(:find).with("37").and_return(mock_footprints_category)
      get :edit, :id => "37"
      assigns[:footprints_category].should equal(mock_footprints_category)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created footprints_category as @footprints_category" do
        FootprintsCategory.stub!(:new).with({'these' => 'params'}).and_return(mock_footprints_category(:save => true))
        post :create, :footprints_category => {:these => 'params'}
        assigns[:footprints_category].should equal(mock_footprints_category)
      end

      it "redirects to the created footprints_category" do
        FootprintsCategory.stub!(:new).and_return(mock_footprints_category(:save => true))
        post :create, :footprints_category => {}
        response.should redirect_to(footprints_categories_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved footprints_category as @footprints_category" do
        FootprintsCategory.stub!(:new).with({'these' => 'params'}).and_return(mock_footprints_category(:save => false))
        post :create, :footprints_category => {:these => 'params'}
        assigns[:footprints_category].should equal(mock_footprints_category)
      end

      it "re-renders the 'new' template" do
        FootprintsCategory.stub!(:new).and_return(mock_footprints_category(:save => false))
        post :create, :footprints_category => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested footprints_category" do
        FootprintsCategory.should_receive(:find).with("37").and_return(mock_footprints_category)
        mock_footprints_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :footprints_category => {:these => 'params'}
      end

      it "assigns the requested footprints_category as @footprints_category" do
        FootprintsCategory.stub!(:find).and_return(mock_footprints_category(:update_attributes => true))
        put :update, :id => "1"
        assigns[:footprints_category].should equal(mock_footprints_category)
      end

      it "redirects to the footprints_category index" do
        FootprintsCategory.stub!(:find).and_return(mock_footprints_category(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(footprints_categories_url)
      end
    end

    describe "with invalid params" do
      it "updates the requested footprints_category" do
        FootprintsCategory.should_receive(:find).with("37").and_return(mock_footprints_category)
        mock_footprints_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :footprints_category => {:these => 'params'}
      end

      it "assigns the footprints_category as @footprints_category" do
        FootprintsCategory.stub!(:find).and_return(mock_footprints_category(:update_attributes => false))
        put :update, :id => "1"
        assigns[:footprints_category].should equal(mock_footprints_category)
      end

      it "re-renders the 'edit' template" do
        FootprintsCategory.stub!(:find).and_return(mock_footprints_category(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested footprints_category" do
      FootprintsCategory.should_receive(:find).with("37").and_return(mock_footprints_category)
      mock_footprints_category.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the footprints_categories list" do
      FootprintsCategory.stub!(:find).and_return(mock_footprints_category(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(footprints_categories_url)
    end
  end

end
