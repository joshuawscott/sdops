require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe ReportsController do
  before(:each) do
    controller.stub!(:login_required)
    controller.stub!(:current_user).and_return(mock_model(User, :has_role? => true, :sugar_team_ids => ""))
    @contract = mock_model(Contract)
  end

  describe "index" do
    before :each do
      Contract.stub!(:all_revenue).and_return(@contract)
      Contract.stub!(:revenue_by_office_by_type).and_return([@contract])
    end
    it "finds all_revenue without parameters when a blank date is searched for" do
      Contract.should_receive(:all_revenue).with(nil)
      get :index, :date => ''
    end

    it "finds all_revenue with a date when a date is searched for" do
      date = Date.parse('2009-08-01')
      Contract.should_receive(:all_revenue).with(date)
      get :index, :date => '08/01/2009'
    end

    it "finds all_revenue without parameters when loading the page without a search" do
      Contract.should_receive(:all_revenue).with(nil)
      get :index
    end

    it "assigns @all_revenue" do
      get :index
      assigns[:all_revenue].should == @contract
    end

    it "finds revenue_by_office_by_type without parameters when a blank date is searched for" do
      Contract.should_receive(:revenue_by_office_by_type).with(nil)
      get :index, :date => ''
    end

    it "finds revenue_by_office_by_type with a date when a date is searched for" do
      date = Date.parse('2009-08-01')
      Contract.should_receive(:revenue_by_office_by_type).with(date)
      get :index, :date => '08/01/2009'
    end

    it "finds revenue_by_office_by_type without parameters when loading the page without a search" do
      Contract.should_receive(:revenue_by_office_by_type).with(nil)
      get :index
    end

    it "assigns @revenue_by_office_by_type" do
      get :index
      assigns[:revenue_by_office_by_type].should == [@contract]
    end
  end

  describe "spares_assessment" do

    before :each do
      @sugar_team = mock_model(SugarTeam, :name => "Dallas")
      SugarTeam.stub!(:dropdown_list).and_return([@sugar_team])
      @lineitem = mock_model(LineItem, :product_num => "A5001", :base_part => "A5001-00000", :qty_instock => 1, :qty_covered => 1, :description => "Description")
      LineItem.stub!(:spares_assessment).and_return([@lineitem])
    end

    it "renders /reports/spares_assessment" do
      get :spares_assessment
      response.should(render_template("spares_assessment"))
    end

    it "assigns a list of the offices to @offices" do
      get :spares_assessment, "filter" => {"office_name" => "Dallas", "offices" => "Dallas"}
      assigns[:offices].should == ['Dallas']
    end

    it "doesn't gather lineitems when no office is searched" do
      get :spares_assessment
      assigns[:lineitems].should == []
    end

    it "gathers a list of lineitems when a office is searched" do
      post :spares_assessment, "filter" => {"office_name" => "Dallas", "offices" => "Dallas"}
      assigns[:lineitems].should == [@lineitem]
    end
  end
end

