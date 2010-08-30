class Ability
  include CanCan::Ability

  def initialize(user)    
    if user.nil?
      can :read, Deal
    elsif user.admin?
      can :manage, :all
    else
      can :read, Deal
      can :create, Deal
      can :update, Deal, :user_id => user.id
      can :destroy, Deal, :user_id => user.id
      can :create, Vote
    end
  end

end
