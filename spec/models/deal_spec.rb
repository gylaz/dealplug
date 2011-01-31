require 'spec_helper'

describe Deal do
  it { should belong_to(:user)}
  it { should have_many(:votes)}
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:url) }
  it { should_not allow_value("badurl").for(:url) }
  it { should_not allow_value("more.badurl").for(:url) }
  it { should_not allow_value("too short").for(:description) }

  let(:deal) {Factory.build :deal, :user => Factory.build(:user)}

  context "creation" do
    subject do
      deal.save
      deal
    end

    its(:errors) { should be_empty }
    its(:points) { should == 1 }
    it           { should have(1).vote }
  end

  context "when validation fails" do
    subject {Factory.build(:deal,:user => deal.user,:slickdeals_id => "12345")}

    before do
      deal.slickdeals_id = "12345"
      deal.save
      subject.save
    end

    it { should_not be_valid }
    it { should have(0).vote }
    its(:errors) { should == {:slickdeals_id => ["has already been taken"]} }
  end

  context "url formatting" do
    it "adds the http prefix" do
      deal.url = "example.com"
      deal.save.should be_true
      deal.url.should == "http://example.com"
    end

    it "leaves the http prefix alone" do
      deal.url = "https://example.com"
      deal.save.should be_true
      deal.url.should == "https://example.com"
    end
  end

  describe "#user_vote" do
    before { deal.save }

    it "finds user's vote" do
      deal.user_vote(deal.user).user.should == deal.user
    end

    it "can't find a vote if user hasn't voted" do
      deal.user_vote(Factory.build :user, :username => "test").should be_nil
    end
  end

  describe "#recalculate_points" do
  end

  describe ".scan_and_populate" do
  end
end
