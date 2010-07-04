class User < ActiveRecord::Base
  has_many :deals
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, 
  # :rememberable, :trackable, :validatable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable
  validates :username, :uniqueness => true, :presence => true
  
  attr_accessible :username, :email, :password, :password_confirmation
  
  def admin?
    admin
  end
end
