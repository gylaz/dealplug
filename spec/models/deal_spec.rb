require 'spec_helper'

describe Deal do
  let(:deal) { Factory(:deal, :user => Factory.build(:user)) }

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

  subject { deal }

  context "creation" do
    its(:errors) { should be_empty }
    its(:points) { should == 1 }
    it           { should have(1).vote }
  end

  context "when validation fails" do
    before do
      deal.slickdeals_id = "12345"
      deal.save
      subject.save
    end

    subject {Factory.build(:deal,:user => deal.user,:slickdeals_id => "12345")}
    it { should_not be_valid }
    it { should have(0).vote }
    its(:errors) { should == {:slickdeals_id => ["has already been taken"]} }
  end

  context "url formatting" do
    context "when prefix not provided" do
      before { deal.url = "example.com"; deal.save }
      its(:url) { should == "http://example.com" }
    end

    context "with prefix" do
      before { deal.url = "https://example.com"; deal.save }
      its(:url) { should == "https://example.com" }
    end
  end

  describe "#user_vote" do
    context "when a user has voted" do
      subject { deal.user_vote(deal.user) }
      its(:user) { should == deal.user }
    end
      
    context "when a user hasn't voted" do
      subject { deal.user_vote(Factory.build :user, :username => "test") }
      it { should be_nil }
    end
  end

  describe "#recalculate_points" do
    before do
      Vote.create :deal_id => deal.id,
        :user_id => Factory(:user, :username => :one).id
      Vote.create :deal_id => deal.id,
        :user_id => Factory(:user, :username => :two).id
      Vote.create :deal_id => deal.id,
        :user_id => Factory(:user, :username => :three).id
      deal.recalculate_points
    end
    its(:points) {should == 4}
  end

  describe ".scan_and_populate" do
    before do
      Factory(:user, :username => :russianbandit)
      SlickdealsParser.should_receive(:parse).with(:score => 15).and_return(
        [ { :title => "Parsed 1", :slickdeals_id => 1, :price => 40,
            :url => "http://amazon.com",
            :description => "This is more than 20 chars"},
          { :title => "Parsed 2", :slickdeals_id => 2, :price => 40,
            :url => "http://amazon.com",
            :description => "This is more than 20 chars"},
        ]
      )
    end
    it "parses and saves new deals" do
      expect { Deal.scan_and_populate }.to change(Deal, :count).by(2)
    end
  end
end
