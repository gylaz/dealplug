require 'spec_helper'

describe User do
  let(:user) { Factory(:user) }
  subject { user.reload }

  it { should have_many(:deals)}
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }

  context "can't set admin flag" do
    before { user.update_attributes(:admin => true) }
    its(:admin?) { should be_false }
  end

  describe "#recalculate_points" do
    context "with several deals" do
      before {
        Factory(:deal, :user => user)
        Factory(:deal, :user => user)
      }
      its(:points) { should == 2 }
    end

    context "and can't force points" do
      before { Factory(:deal, :user => user, :points => 5) }
      its(:points) { should == 1 }
    end
  end
end
