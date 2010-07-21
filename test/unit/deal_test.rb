require 'test_helper'

class DealTest < ActiveSupport::TestCase

  test "create" do
    deal = Deal.new
    assert !deal.save
    assert_equal 7, deal.errors.size
    assert_not_nil deal.errors[:title]
    assert_not_nil deal.errors[:description]
    
    deal = Deal.new(:title => "Test", :url => "", :price => "99",
      :description => "this is a test that is longer than 20 characters")
      assert !deal.save      
    assert_equal 3, deal.errors.size
    assert_not_nil deal.errors[:user]
    assert_not_nil deal.errors[:url]
    
    deal = Deal.new(:title => "Test", :url => "http://test", :price => "99", :points => 999,
      :description => "This is a test that is longer than 20 characters")
    deal.user = users(:admin)
    assert deal.save
    assert_equal 1, deal.points
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
  
  test "user vote" do
    
  end
end
