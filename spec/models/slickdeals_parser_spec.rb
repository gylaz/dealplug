require 'spec_helper'

describe SlickdealsParser do
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

  before do
   stub_request(:get, 'http://slickdeals.net/forums/forumdisplay.php?f=9').
     to_return(:body => forum_fragment)
   stub_request(:get, /slickdeals\.net\/forums\/showthread/).
     to_return(:body => post_fragment)
  end
  let(:deals) { SlickdealsParser.parse }

  specify { deals.should have(1).item }

  subject { deals.first }
  its([:slickdeals_id]) { should == "2493887" }
  its([:title]) { should == "PlayStation 3 160GB Slim Console $199" }
  its([:price]) { should == 199 }
  its([:url]) { should == "http://www.amazon.com" }
  its([:description]) { should =~ /Hi, this is some text/ }
end

