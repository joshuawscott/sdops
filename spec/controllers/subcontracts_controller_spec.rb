require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubcontractsController do

  before(:each) do
    controller.stub!(:login_required)
  end

  def mock_subcontract(stubs={})
    @mock_subcontract ||= mock_model(Subcontract, stubs)
  end
  
  describe "GET index" do
    it "assigns all subcontracts as @subcontracts" do
      Subcontract.stub!(:find).with(:all).and_return([mock_subcontract])
      Subcontract.should_not_receive(:find).with(:all, :conditions => {:subcontractor_id => params[:subcontractor]})
      get :index
      assigns[:subcontracts].should == [mock_subcontract]
    end
    it "assigns contracts with found subcontractor_id when it receives subcontractor as a parameter" do
      Subcontract.should_receive(:find).with(:all, :conditions => {:subcontractor_id => "27"}).and_return([mock_subcontract])
      get :index, :subcontractor => "27"
      assigns[:subcontracts].should == [mock_subcontract]
    end
  end

  describe "GET show" do
    it "assigns the requested subcontract as @subcontract" do
      Subcontract.stub!(:find).with("37").and_return(mock_subcontract)
      get :show, :id => "37"
      assigns[:subcontract].should equal(mock_subcontract)
    end
  end

  describe "GET new" do
    it "assigns a new subcontract as @subcontract" do
      Subcontract.stub!(:new).and_return(mock_subcontract)
      get :new
      assigns[:subcontract].should equal(mock_subcontract)
    end

    it "assigns the subcontractor list as @subcontractors" do
      mock_subcontractor = mock_model(Subcontractor)
      Subcontractor.stub!(:find).with(:all).and_return([mock_subcontractor])
      get :new
      assigns[:subcontractors].should == [mock_subcontractor]
    end
  end

  describe "GET edit" do
    it "assigns the requested subcontract as @subcontract" do
      Subcontract.stub!(:find).with("37").and_return(mock_subcontract)
      get :edit, :id => "37"
      assigns[:subcontract].should equal(mock_subcontract)
    end

    it "assigns the subcontractor list as @subcontractors" do
      mock_subcontractor = mock(Subcontractor)
      Subcontractor.stub!(:find).with(:all).and_return([mock_subcontractor])
      get :new
      assigns[:subcontractors].should == [mock_subcontractor]
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created subcontract as @subcontract" do
        Subcontract.stub!(:new).with({'these' => 'params'}).and_return(mock_subcontract(:save => true))
        post :create, :subcontract => {:these => 'params'}
        assigns[:subcontract].should equal(mock_subcontract)
      end

      it "redirects to the created subcontract" do
        Subcontract.stub!(:new).and_return(mock_subcontract(:save => true))
        post :create, :subcontract => {}
        response.should redirect_to(subcontract_url(mock_subcontract))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved subcontract as @subcontract" do
        Subcontract.stub!(:new).with({'these' => 'params'}).and_return(mock_subcontract(:save => false))
        post :create, :subcontract => {:these => 'params'}
        assigns[:subcontract].should equal(mock_subcontract)
      end

      it "re-renders the 'new' template" do
        Subcontract.stub!(:new).and_return(mock_subcontract(:save => false))
        post :create, :subcontract => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT update" do
    
    describe "with valid params" do
      it "updates the requested subcontract" do
        Subcontract.should_receive(:find).with("37").and_return(mock_subcontract)
        mock_subcontract.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :subcontract => {:these => 'params'}
      end

      it "assigns the requested subcontract as @subcontract" do
        Subcontract.stub!(:find).and_return(mock_subcontract(:update_attributes => true))
        put :update, :id => "1"
        assigns[:subcontract].should equal(mock_subcontract)
      end

      it "redirects to the subcontract" do
        Subcontract.stub!(:find).and_return(mock_subcontract(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(subcontract_url(mock_subcontract))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested subcontract" do
        Subcontract.should_receive(:find).with("37").and_return(mock_subcontract)
        mock_subcontract.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :subcontract => {:these => 'params'}
      end

      it "assigns the subcontract as @subcontract" do
        Subcontract.stub!(:find).and_return(mock_subcontract(:update_attributes => false))
        put :update, :id => "1"
        assigns[:subcontract].should equal(mock_subcontract)
      end

      it "re-renders the 'edit' template" do
        Subcontract.stub!(:find).and_return(mock_subcontract(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested subcontract" do
      Subcontract.should_receive(:find).with("37").and_return(mock_subcontract)
      mock_subcontract.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the subcontracts list" do
      Subcontract.stub!(:find).and_return(mock_subcontract(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(subcontracts_url)
    end
  end

  describe "POST add_line_items" do
    before(:each) do
      @mock_line_item = mock_model(LineItem)
      @mock_line_item.stub!(:update_attribute).and_return true
      Subcontract.stub!(:find).with("27").and_return(mock_subcontract(:id => 27, :line_items => [@mock_line_item]))
      LineItem.stub!(:find).with("123").and_return(@mock_line_item)
    end

    it "finds a subcontract to add lines to" do
      Subcontract.should_receive(:find).with("27")
      post :add_line_items, :id => '27', "line_items" => [{"id" => "123", "subcontract_cost" => "5"}]
      assigns[:subcontract].should == mock_subcontract
    end

    it "finds line items to add to the subcontracts" do
      LineItem.should_receive(:find).with("123")
      post :add_line_items, :id => '27', "line_items" => [{"id" => "123", "subcontract_cost" => "5"}]
      assigns[:line_item].should == @mock_line_item
    end

    it "updates the subcontract_cost of the line items" do
      @mock_line_item.should_receive(:update_attribute).with("subcontract_cost", "5")
      post :add_line_items, :id => '27', "line_items" => [{"id" => "123", "subcontract_cost" => "5"}]
    end

    it "adds the line items to the subcontract" do
      @mock_subcontract.line_items.should_receive("<<").with(@mock_line_item)
      post :add_line_items, :id => '27', "line_items" => [{"id" => "123", "subcontract_cost" => "5"}]
    end

    it "redirects to the subcontract show page" do
      post :add_line_items, :id => '27', "line_items" => [{"id" => "123", "subcontract_cost" => "5"}]
      response.should redirect_to(subcontract_path(27))
    end
  end

end
