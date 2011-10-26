class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :deal
  validates :user_id, :presence => true, :uniqueness => {:scope => :deal_id}
  validates :deal_id, :presence => true

  after_create :recalculate_points

  def recalculate_points
    deal.recalculate_points
    user.recalculate_points
  end
end
