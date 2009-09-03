require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
describe 'contracts/simple_show.html.haml' do
  before(:each) do
    @line_item = mock_model(LineItem, :null_object => true)
    @contract = mock_model(Contract, :line_items => [@line_item], :null_object => true)
    assigns[:contract] = @contract
    assigns[:replaced_by] = [@contract]
    assigns[:replaces] = [@contract]
    @comment = mock_model(Comment, :null_object => true)
    assigns[:comment] = @comment
    assigns[:comments] = [@comment]
    assigns[:hwlines] = [@line_item]
    assigns[:swlines] = [@line_item]
    assigns[:srvlines] = [@line_item]

    template.stub!(:current_user).and_return(mock_model(User, :null_object => true, :has_role? => true))

    render "contracts/simple_show.html.haml"
  end

  it "doesn't show the revenue box" do
    response.should have_selector("#section2")
    response.should_not have_selector("#section2", :content => "Revenue")
  end
end

