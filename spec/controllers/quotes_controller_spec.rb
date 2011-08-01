require 'spec_helper'

describe QuotesController do
  before(:each) do
    controller.stub!(:login_required)
    controller.stub!(:authorized?)
    controller.stub!(:current_user).and_return(mock_model(User, :has_role? => true, :sugar_team_ids => ""))
  end

  def mock_quote(stubs={})
    @mock_quote ||= mock_model(Quote, stubs)
  end
  def mock_comment
    @mock_comment ||= mock_model(Comment)
  end
  def mock_line_item(stubs={})
    stubs[:position] ||= 1
    stubs[:support_type] ||= "HW"
    @mock_line_item ||= mock_model(LineItem, stubs)
  end
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  describe "GET index" do
    it "assigns all quotes as @quotes" do
      Quote.stub!(:find).with(:all).and_return([mock_quote])
      get :index
      assigns[:quotes].should == [mock_quote]
    end
  end

  describe "GET show" do
    before(:each) do
      @mock_user = mock("user")
      Quote.stub!(:find).with("37").and_return(mock_quote(:line_items => [mock_line_item()], :comments => [mock_comment]), :sales_rep_id => 1)
      User.stub!(:find).and_return(@mock_user)
      @mock_user.should_receive(:full_name).and_return("John Doe")
      mock_quote.should_receive(:comments).and_return([mock_comment])
      mock_quote.should_receive(:line_items).and_return([mock_line_item])
      mock_quote.should_receive(:sales_rep_id).and_return 1
      get :show, :id => "37"
    end
    it "assigns the requested quote as @quote" do
      assigns[:quote].should equal(mock_quote)
    end
    it "assigns the comments for the quote as @comments" do
      assigns[:comments].should == [mock_comment]
    end
    it "assigns the line_items for the quote to @line_items" do
      assigns[:line_items].should == [mock_line_item]
    end
    it "assigns the various support types to their own vars" do
      # Note that we are only assigning the hw line item.
      assigns[:hwlines].should == [mock_line_item]
      assigns[:swlines].should == []
      assigns[:srvlines].should == []
    end
    it "assigns Sales Rep full name to @sales_rep" do
      assigns[:sales_rep].should == "John Doe"
    end
  end

  describe "GET new" do
    it "assigns a new quote as @quote" do
      Quote.stub!(:new).and_return(mock_quote)
      get :new
      assigns[:quote].should equal(mock_quote)
    end
  end

  describe "GET edit" do
    it "assigns the requested quote as @quote" do
      Quote.stub!(:find).with("37").and_return(mock_quote)
      get :edit, :id => "37"
      assigns[:quote].should equal(mock_quote)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created quote as @quote" do
        Quote.stub!(:new).with({'these' => 'params'}).and_return(mock_quote(:save => true))
        post :create, :quote => {:these => 'params'}
        assigns[:quote].should equal(mock_quote)
      end

      it "redirects to the created quote" do
        Quote.stub!(:new).and_return(mock_quote(:save => true))
        post :create, :quote => {}
        response.should redirect_to(quote_url(mock_quote))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved quote as @quote" do
        Quote.stub!(:new).with({'these' => 'params'}).and_return(mock_quote(:save => false))
        post :create, :quote => {:these => 'params'}
        assigns[:quote].should equal(mock_quote)
      end

      it "re-renders the 'new' template" do
        Quote.stub!(:new).and_return(mock_quote(:save => false))
        post :create, :quote => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested quote" do
        Quote.should_receive(:find).with("37").and_return(mock_quote)
        mock_quote.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :quote => {:these => 'params'}
      end

      it "assigns the requested quote as @quote" do
        Quote.stub!(:find).and_return(mock_quote(:update_attributes => true))
        put :update, :id => "1"
        assigns[:quote].should equal(mock_quote)
      end

      it "redirects to the quote" do
        Quote.stub!(:find).and_return(mock_quote(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(quote_url(mock_quote))
      end
    end

    describe "with invalid params" do
      it "updates the requested quote" do
        Quote.should_receive(:find).with("37").and_return(mock_quote)
        mock_quote.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :quote => {:these => 'params'}
      end

      it "assigns the quote as @quote" do
        Quote.stub!(:find).and_return(mock_quote(:update_attributes => false))
        put :update, :id => "1"
        assigns[:quote].should equal(mock_quote)
      end

      it "re-renders the 'edit' template" do
        Quote.stub!(:find).and_return(mock_quote(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested quote" do
      Quote.should_receive(:find).with("37").and_return(mock_quote)
      mock_quote.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the quote list" do
      Quote.stub!(:find).and_return(mock_quote(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(quotes_url)
    end
  end

end
