class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    can :read, Deal
    if user.admin?
      can :manage, :all
    else
      can :create, Deal
      can :update, Deal, :user_id => user.id
      can :destroy, Deal, :user_id => user.id
    end
  end

end
