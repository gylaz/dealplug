require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  
  test "update points" do
    vote = Vote.create(:deal => deals(:one), :user => users(:user2), :up => true)
    assert_equal 2, deals(:one).points
    assert_equal 1001, deals(:one).user.points
    
    vote.update_attribute(:up, true)
    assert_equal 2, deals(:one).points
    assert_equal 1001, deals(:one).user.points
    
    vote.update_attribute(:up, false)
    assert_equal 0, deals(:one).points
    assert_equal 999, deals(:one).user.points
    
    vote.update_attribute(:up, false)
    assert_equal 0, deals(:one).points
    assert_equal 2, deals(:one).user.points
    
    vote = Vote.create(:deal => deals(:one), :user => users(:admin), :up => false)
    assert_equal -1, deals(:one).points
    assert_equal 2, deals(:one).user.points
    
    vote = Vote.create(:deal => deals(:one), :user => users(:user2), :up => false)
    assert_equal -2, deals(:one).points
    assert_equal 2, deals(:one).user.points
  end
end
