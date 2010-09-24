require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  test "should create vote" do
    sign_in users(:user1)
    deal = deals(:one)
    assert_difference('Vote.count') do
      xhr :post, :create, :deal_id => deal.id
    end
    assert_equal deal.points + 1, deal.reload.points
    assert_response :success
  end
end
