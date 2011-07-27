require 'spec_helper'

describe Vote do
  before { Factory(:vote) }
  it { should belong_to(:user)}
  it { should belong_to(:deal)}
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:deal_id) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:deal_id) }
end
