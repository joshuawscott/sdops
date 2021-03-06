require 'spec_helper'

describe ManufacturersController do

  def mock_manufacturer(stubs={})
    @mock_manufacturer ||= mock_model(Manufacturer, stubs)
  end

  before(:each) do
    controller.stub!(:login_required)
  end

  describe "GET index" do
    it "assigns all manufacturers as @manufacturers" do
      Manufacturer.stub!(:find).with(:all).and_return([mock_manufacturer])
      get :index
      assigns[:manufacturers].should == [mock_manufacturer]
    end
  end

  describe "GET show" do
    it "assigns the requested manufacturer as @manufacturer" do
      Manufacturer.stub!(:find).with("37").and_return(mock_manufacturer)
      get :show, :id => "37"
      assigns[:manufacturer].should equal(mock_manufacturer)
    end
  end

  describe "GET new" do
    it "assigns a new manufacturer as @manufacturer" do
      Manufacturer.stub!(:new).and_return(mock_manufacturer)
      get :new
      assigns[:manufacturer].should equal(mock_manufacturer)
    end
  end

  describe "GET edit" do
    it "assigns the requested manufacturer as @manufacturer" do
      Manufacturer.stub!(:find).with("37").and_return(mock_manufacturer)
      get :edit, :id => "37"
      assigns[:manufacturer].should equal(mock_manufacturer)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created manufacturer as @manufacturer" do
        Manufacturer.stub!(:new).with({'these' => 'params'}).and_return(mock_manufacturer(:save => true))
        post :create, :manufacturer => {:these => 'params'}
        assigns[:manufacturer].should equal(mock_manufacturer)
      end

      it "redirects to the created manufacturer" do
        Manufacturer.stub!(:new).and_return(mock_manufacturer(:save => true))
        post :create, :manufacturer => {}
        response.should redirect_to(manufacturer_url(mock_manufacturer))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved manufacturer as @manufacturer" do
        Manufacturer.stub!(:new).with({'these' => 'params'}).and_return(mock_manufacturer(:save => false))
        post :create, :manufacturer => {:these => 'params'}
        assigns[:manufacturer].should equal(mock_manufacturer)
      end

      it "re-renders the 'new' template" do
        Manufacturer.stub!(:new).and_return(mock_manufacturer(:save => false))
        post :create, :manufacturer => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested manufacturer" do
        Manufacturer.should_receive(:find).with("37").and_return(mock_manufacturer)
        mock_manufacturer.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :manufacturer => {:these => 'params'}
      end

      it "assigns the requested manufacturer as @manufacturer" do
        Manufacturer.stub!(:find).and_return(mock_manufacturer(:update_attributes => true))
        put :update, :id => "1"
        assigns[:manufacturer].should equal(mock_manufacturer)
      end

      it "redirects to the manufacturer" do
        Manufacturer.stub!(:find).and_return(mock_manufacturer(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(manufacturer_url(mock_manufacturer))
      end
    end

    describe "with invalid params" do
      it "updates the requested manufacturer" do
        Manufacturer.should_receive(:find).with("37").and_return(mock_manufacturer)
        mock_manufacturer.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :manufacturer => {:these => 'params'}
      end

      it "assigns the manufacturer as @manufacturer" do
        Manufacturer.stub!(:find).and_return(mock_manufacturer(:update_attributes => false))
        put :update, :id => "1"
        assigns[:manufacturer].should equal(mock_manufacturer)
      end

      it "re-renders the 'edit' template" do
        Manufacturer.stub!(:find).and_return(mock_manufacturer(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested manufacturer" do
      Manufacturer.should_receive(:find).with("37").and_return(mock_manufacturer)
      mock_manufacturer.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the manufacturers list" do
      Manufacturer.stub!(:find).and_return(mock_manufacturer(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(manufacturers_url)
    end
  end

end
