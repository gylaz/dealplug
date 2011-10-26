require 'spec_helper'

describe VotesController do
  let(:user) { Factory(:user, :username => 'newone') }
  let(:deal) { Factory(:deal) }

  before { sign_in user }

  describe "create" do
    before { xhr :post, :create, :deal_id => deal.id }
    it { response.should be_success }
    it { assigns(:deal).should_not be_nil }
    it { Vote.count.should == 2 }

    it "increases deal's points" do
      Deal.find(deal.id).points.should == 2
    end
  end
end
