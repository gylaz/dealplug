require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  test "should create vote" do
    sign_in users(:user1)
    deal = deals(:one)
    assert_difference('Vote.count') do
      post :create, :deal_id => deal.id
    end
    assert_redirected_to deals_path
  end
end
