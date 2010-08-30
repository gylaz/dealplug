require 'test_helper'

class DealsControllerTest < ActionController::TestCase
  setup do
    @deal = deals(:three)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:deals)
  end

  test "should get new" do
    sign_in users(:user1)
    get :new
    assert_response :success
  end

  test "should create deal" do
    sign_in users(:user1)
    assert_difference(['Deal.count', 'Vote.count']) do
      post :create, :deal => @deal.attributes
    end
    assert_redirected_to deal_path(assigns(:deal))
  end

  test "should show deal" do
    get :show, :id => @deal.to_param
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:user1)
    get :edit, :id => @deal.to_param
    assert_response :success
  end

  test "should update deal" do
    sign_in users(:user1)
    put :update, :id => @deal.to_param, :deal => @deal.attributes
    assert_redirected_to deal_path(assigns(:deal))
  end

  test "should destroy deal" do
    sign_in users(:user1)
    assert_difference('Deal.count', -1) do
      delete :destroy, :id => @deal.to_param
    end
    assert_redirected_to deals_path
  end
end
