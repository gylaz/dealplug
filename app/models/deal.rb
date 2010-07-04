class Deal < ActiveRecord::Base
  belongs_to :user
  validates :user, :presence => true
  validates :title, :presence => true
  validates :price, :presence => true
  validates :url, :presence => true, :format => { :with => URI::regexp(%w(http https)) }
  validates :description, :presence => true, :length => { :minimum => 20 }
  
  scope :latest, :order => "created_at ASC"
  scope :popular, :order => "points"
  
  attr_accessible :title, :price, :url, :description
end
