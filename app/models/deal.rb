class Deal < ActiveRecord::Base
  URL_FORMAT = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

  belongs_to :user
  has_many :votes
  validates :user, :presence => true
  validates :title, :presence => true
  validates :price, :presence => true
  validates :url, :presence => true, :format => { :with => URL_FORMAT }
  validates :description, :presence => true, :length => { :minimum => 20 }
  validates :slickdeals_id, :uniqueness => true, :unless => Proc.new { |deal| deal.slickdeals_id.nil? }

  scope :latest, :order => "created_at DESC"
  scope :popular, where(:created_at => (DateTime.now - 5)..DateTime.now).order("points DESC")
  
  attr_accessible :title, :price, :url, :description, :slickdeals_id
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

  def self.scan_and_populate
    deals = SlickdealsParser.parse(:score => 15)

    deals.each do |hash|
      user = User.find_by_username('russianbandit')
      next if Deal.find_by_slickdeals_id(hash[:slickdeals_id])

      deal = Deal.new(:title => hash[:title],
                      :slickdeals_id => hash[:slickdeals_id],
                      :price => hash[:price], :url => hash[:url],
                      :description => hash[:description])
      deal.user = user
      unless deal.save
        puts deal.title
        puts deal.errors.full_messages
      end
    end
  end
end
