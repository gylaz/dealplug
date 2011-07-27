require 'spec_helper'

describe User do
  let(:user) { Factory(:user) }
  subject { user }

  it { should have_many(:deals)}
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }

  context "can't set admin flag" do
    before { user.update_attributes(:admin => true) }
    its(:admin?) { should be_false }
  end

  describe "#recalculate_points" do
    before {
      Factory(:deal, :user => user)
      user.recalculate_points
    }
    its(:points) { should == 1 }
    
    context "with another deal" do
      before {
        Factory(:deal, :user => user, :points => 3)
        user.recalculate_points
      }
      its(:points) { should == 4 }
    end
  end
end
