require 'test_helper'

class DealTest < ActiveSupport::TestCase

  test "create" do
    deal = Deal.new
    assert !deal.save
    assert_equal 7, deal.errors.size
    assert_not_nil deal.errors[:title]
    assert_not_nil deal.errors[:description]
    assert deal.votes.empty?
    
    deal = Deal.new(:title => "Test", :url => "", :price => "99",
      :description => "this is a test that is longer than 20 characters")
      assert !deal.save      
    assert_equal 3, deal.errors.size
    assert_not_nil deal.errors[:user]
    assert_not_nil deal.errors[:url]
    assert deal.votes.empty?
    
    deal = Deal.new(:title => "Test", :url => "http://test", :price => "99", :points => 999,
      :description => "This is a test that is longer than 20 characters")
    deal.user = users(:admin)
    assert deal.save
    assert_equal 1, deal.points
    assert_equal 1, deal.votes.size
  end
  
  test "format url" do
    deal = Deal.new(:title => "Test", :url => "test", :price => "99",
      :description => "This is a test that is longer than 20 characters")
    deal.user = users(:admin)
    assert deal.save
    assert_equal "http://test", deal.url
    
    deal.url = "https://new"
    assert deal.save
    assert_equal "https://new", deal.url
  end
  
  test "vote gets assigned correctly" do
    deal = deals(:three)
    assert_equal votes(:three), deal.user_vote(users(:user1))

    vote = Vote.create(:deal => deal, :user => users(:admin))
    assert_equal vote, deal.user_vote(users(:admin))
  end

  test "duplicate slickdeals id" do
    deal = Deal.new(:title => "Test", :url => "test", :price => "99", :slickdeals_id => 1234,
      :description => "This is a test that is longer than 20 characters")
    deal.user = users(:admin)
    assert deal.save

    deal_dup = Deal.new(deal.attributes)
    deal_dup.user = users(:admin)
    deal_dup.slickdeals_id = deal.slickdeals_id
    assert !deal_dup.save
    assert_equal ["Slickdeals has already been taken"], deal_dup.errors.full_messages
  end
end
