class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :deal
  validates :user_id, :presence => true, :uniqueness => {:scope => :deal_id}
  validates :deal_id, :presence => true
end
