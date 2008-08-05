require File.dirname(__FILE__) + '/../spec_helper'

describe ImportController do

  def do_get
    get :index
  end

  it 'imports contract' do
    do_get
    response.should be_success
  end

end
