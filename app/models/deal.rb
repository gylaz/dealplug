class Deal < ActiveRecord::Base
  belongs_to :user
  has_many :votes
  validates :user, :presence => true
  validates :title, :presence => true
  validates :price, :presence => true
  validates :url, :presence => true, :format => { :with => URI::regexp(%w(http https)) }
  validates :description, :presence => true, :length => { :minimum => 20 }
  
  scope :latest, :order => "created_at DESC"
  scope :popular, where(:created_at => (DateTime.now - 5)..DateTime.now).order("points DESC")
  
  attr_accessible :title, :price, :url, :description
  before_validation :format_url
  after_create :create_vote
  
  def create_vote
    Vote.create(:deal_id => id, :user_id => user.id)
  end
  
  def format_url
    unless url.blank? or url.starts_with?("http://") or url.starts_with?("https://")
      self.url = "http://" + url
    end
  end
  
  def user_vote(user)
    votes.find_by_user_id(user.id) if user
  end
  
  def recalculate_points
    sum = votes.where(:deal_id => id).count
    update_attribute(:points, sum)
  end
end
