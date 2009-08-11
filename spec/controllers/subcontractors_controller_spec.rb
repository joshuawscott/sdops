require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubcontractorsController do

  def mock_subcontractor(stubs={})
    @mock_subcontractor ||= mock_model(Subcontractor, stubs)
  end

  before(:each) do
    controller.stub!(:login_required)
  end

  describe "GET index" do
    it "assigns all subcontractors as @subcontractors" do
      Subcontractor.stub!(:find).with(:all).and_return([mock_subcontractor])
      get :index
      assigns[:subcontractors].should == [mock_subcontractor]
    end
  end

  describe "GET show" do
    it "assigns the requested subcontractor as @subcontractor" do
      Subcontractor.stub!(:find).with("37").and_return(mock_subcontractor)
      get :show, :id => "37"
      assigns[:subcontractor].should == mock_subcontractor
    end
  end

  describe "GET new" do
    it "assigns a new subcontractor as @subcontractor" do
      Subcontractor.stub!(:new).and_return(mock_subcontractor)
      get :new
      assigns[:subcontractor].should == mock_subcontractor
    end
  end

  describe "GET edit" do
    it "assigns the requested subcontractor as @subcontractor" do
      Subcontractor.stub!(:find).with("37").and_return(mock_subcontractor)
      get :edit, :id => "37"
      assigns[:subcontractor].should == mock_subcontractor
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created subcontractor as @subcontractor" do
        Subcontractor.stub!(:new).with({'these' => 'params'}).and_return(mock_subcontractor(:save => true))
        post :create, :subcontractor => {:these => 'params'}
        assigns[:subcontractor].should == mock_subcontractor
      end

      it "redirects to the created subcontractor" do
        Subcontractor.stub!(:new).and_return(mock_subcontractor(:save => true))
        post :create, :subcontractor => {}
        response.should redirect_to(subcontractor_url(mock_subcontractor))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved subcontractor as @subcontractor" do
        Subcontractor.stub!(:new).with({'these' => 'params'}).and_return(mock_subcontractor(:save => false))
        post :create, :subcontractor => {:these => 'params'}
        assigns[:subcontractor].should == mock_subcontractor
      end

      it "re-renders the 'new' template" do
        Subcontractor.stub!(:new).and_return(mock_subcontractor(:save => false))
        post :create, :subcontractor => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested subcontractor" do
        Subcontractor.should_receive(:find).with("37").and_return(mock_subcontractor)
        mock_subcontractor.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :subcontractor => {:these => 'params'}
      end

      it "assigns the requested subcontractor as @subcontractor" do
        Subcontractor.stub!(:find).and_return(mock_subcontractor(:update_attributes => true))
        put :update, :id => "1"
        assigns[:subcontractor].should == mock_subcontractor
      end

      it "redirects to the subcontractor" do
        Subcontractor.stub!(:find).and_return(mock_subcontractor(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(subcontractor_url(mock_subcontractor))
      end
    end

    describe "with invalid params" do
      it "updates the requested subcontractor" do
        Subcontractor.should_receive(:find).with("37").and_return(mock_subcontractor)
        mock_subcontractor.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :subcontractor => {:these => 'params'}
      end

      it "assigns the subcontractor as @subcontractor" do
        Subcontractor.stub!(:find).and_return(mock_subcontractor(:update_attributes => false))
        put :update, :id => "1"
        assigns[:subcontractor].should == mock_subcontractor
      end

      it "re-renders the 'edit' template" do
        Subcontractor.stub!(:find).and_return(mock_subcontractor(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested subcontractor" do
      Subcontractor.should_receive(:find).with("37").and_return(mock_subcontractor)
      mock_subcontractor.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the subcontractors list" do
      Subcontractor.stub!(:find).and_return(mock_subcontractor(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(subcontractors_url)
    end
  end

end
