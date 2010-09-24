require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  
  test "update points" do
    vote = Vote.create(:deal => deals(:one), :user => users(:user1))
    assert_equal 2, deals(:one).points
    assert_equal 1001, deals(:one).user.points
    
    vote = Vote.create(:deal => deals(:one), :user => users(:user2))
    assert_equal 3, deals(:one).points
    assert_equal 1002, deals(:one).user.points
    
    vote = Vote.create(:deal => deals(:one), :user => users(:user2))
    assert_equal 3, deals(:one).points
    assert_equal 1002, deals(:one).user.points
  end
end
