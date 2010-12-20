require 'test_helper'

class SlickdealsParserTest < ActiveSupport::TestCase

  def forum_fragment
    %q(<tr id="sdpostrow_12345">
      <td>
      <div>
        <a href="showthread.php?sduid=406874&amp;t=2493887" id="thread_title_2493887"
          style="font-weight:bold">PlayStation 3 160GB Slim Console $199</a>
      </div>
      <div><span>
        <img class="concat-thumbs" alt="Votes: 31 Score: 23">
      </span></div>
      </td></tr>)
  end

  def post_fragment
    %q(<div class="firstthread_title">PlayStation 3 160GB Slim Console $199</div>
      <div class="post_message">
        Hi, this is some text
        Go to <a href="http://slickdeals.net/blablah=http://www.amazon.com">here</a> to purchase
      </div>)
  end

  def setup
   stub_request(:get, 'http://slickdeals.net/forums/forumdisplay.php?f=9').to_return(:body => forum_fragment)
   stub_request(:get, /slickdeals\.net\/forums\/showthread/).to_return(:body => post_fragment)
  end

  test "parsing good html" do
    results = SlickdealsParser.parse
    assert_equal 1, results.size
    assert_equal "2493887", results.first[:slickdeals_id]
    assert_equal "PlayStation 3 160GB Slim Console $199", results.first[:title]
    assert_equal 199, results.first[:price]
    assert_equal "http://www.amazon.com", results.first[:url]
    assert_match /Hi, this is some text/, results.first[:description]
  end
end
