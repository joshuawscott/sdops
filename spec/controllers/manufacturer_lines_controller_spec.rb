require 'spec_helper'

describe ManufacturerLinesController do

  def mock_manufacturer_line(stubs={})
    @mock_manufacturer_line ||= mock_model(ManufacturerLine, stubs)
  end

  before(:each) do
    controller.stub!(:login_required)
  end

  describe "GET index" do
    it "assigns all manufacturer_lines as @manufacturer_lines" do
      ManufacturerLine.stub!(:find).with(:all).and_return([mock_manufacturer_line])
      get :index
      assigns[:manufacturer_lines].should == [mock_manufacturer_line]
    end
  end

  describe "GET show" do
    it "assigns the requested manufacturer_line as @manufacturer_line" do
      ManufacturerLine.stub!(:find).with("37").and_return(mock_manufacturer_line)
      get :show, :id => "37"
      assigns[:manufacturer_line].should equal(mock_manufacturer_line)
    end
  end

  describe "GET new" do
    it "assigns a new manufacturer_line as @manufacturer_line" do
      ManufacturerLine.stub!(:new).and_return(mock_manufacturer_line)
      get :new
      assigns[:manufacturer_line].should equal(mock_manufacturer_line)
    end
  end

  describe "GET edit" do
    it "assigns the requested manufacturer_line as @manufacturer_line" do
      ManufacturerLine.stub!(:find).with("37").and_return(mock_manufacturer_line)
      get :edit, :id => "37"
      assigns[:manufacturer_line].should equal(mock_manufacturer_line)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created manufacturer_line as @manufacturer_line" do
        ManufacturerLine.stub!(:new).with({'these' => 'params'}).and_return(mock_manufacturer_line(:save => true))
        post :create, :manufacturer_line => {:these => 'params'}
        assigns[:manufacturer_line].should equal(mock_manufacturer_line)
      end

      it "redirects to the created manufacturer_line" do
        ManufacturerLine.stub!(:new).and_return(mock_manufacturer_line(:save => true))
        post :create, :manufacturer_line => {}
        response.should redirect_to(manufacturer_line_url(mock_manufacturer_line))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved manufacturer_line as @manufacturer_line" do
        ManufacturerLine.stub!(:new).with({'these' => 'params'}).and_return(mock_manufacturer_line(:save => false))
        post :create, :manufacturer_line => {:these => 'params'}
        assigns[:manufacturer_line].should equal(mock_manufacturer_line)
      end

      it "re-renders the 'new' template" do
        ManufacturerLine.stub!(:new).and_return(mock_manufacturer_line(:save => false))
        post :create, :manufacturer_line => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested manufacturer_line" do
        ManufacturerLine.should_receive(:find).with("37").and_return(mock_manufacturer_line)
        mock_manufacturer_line.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :manufacturer_line => {:these => 'params'}
      end

      it "assigns the requested manufacturer_line as @manufacturer_line" do
        ManufacturerLine.stub!(:find).and_return(mock_manufacturer_line(:update_attributes => true))
        put :update, :id => "1"
        assigns[:manufacturer_line].should equal(mock_manufacturer_line)
      end

      it "redirects to the manufacturer_line" do
        ManufacturerLine.stub!(:find).and_return(mock_manufacturer_line(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(manufacturer_line_url(mock_manufacturer_line))
      end
    end

    describe "with invalid params" do
      it "updates the requested manufacturer_line" do
        ManufacturerLine.should_receive(:find).with("37").and_return(mock_manufacturer_line)
        mock_manufacturer_line.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :manufacturer_line => {:these => 'params'}
      end

      it "assigns the manufacturer_line as @manufacturer_line" do
        ManufacturerLine.stub!(:find).and_return(mock_manufacturer_line(:update_attributes => false))
        put :update, :id => "1"
        assigns[:manufacturer_line].should equal(mock_manufacturer_line)
      end

      it "re-renders the 'edit' template" do
        ManufacturerLine.stub!(:find).and_return(mock_manufacturer_line(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested manufacturer_line" do
      ManufacturerLine.should_receive(:find).with("37").and_return(mock_manufacturer_line)
      mock_manufacturer_line.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the manufacturer_lines list" do
      ManufacturerLine.stub!(:find).and_return(mock_manufacturer_line(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(manufacturer_lines_url)
    end
  end

end
