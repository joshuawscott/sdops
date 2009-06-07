require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:roles)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_roles
    assert_difference('Roles.count') do
      post :create, :roles => { }
    end

    assert_redirected_to roles_path(assigns(:roles))
  end

  def test_should_show_roles
    get :show, :id => roles(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => roles(:one).id
    assert_response :success
  end

  def test_should_update_roles
    put :update, :id => roles(:one).id, :roles => { }
    assert_redirected_to roles_path(assigns(:roles))
  end

  def test_should_destroy_roles
    assert_difference('Roles.count', -1) do
      delete :destroy, :id => roles(:one).id
    end

    assert_redirected_to roles_path
  end
end
