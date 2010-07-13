class Deal < ActiveRecord::Base
  belongs_to :user
  has_many :votes
  validates :user, :presence => true
  validates :title, :presence => true
  validates :price, :presence => true
  validates :url, :presence => true, :format => { :with => URI::regexp(%w(http https)) }
  validates :description, :presence => true, :length => { :minimum => 20 }
  
  scope :latest, :order => "created_at ASC"
  scope :popular, :order => "points"
  
  attr_accessible :title, :price, :url, :description
  before_validation :format_url
  
  def format_url
    unless url.blank? or url.starts_with?("http://") or url.starts_with?("https://")
      self.url = "http://" + url
    end
  end
  
  def user_vote(user)
    votes.find_by_user_id(current_user.id) if user
  end
end
