
class Ability
  include CanCan::Ability
    def initialize(user)
      return unless user.present?
      can %i[read buy_plan], Plan
      can %i[show], Recipe
      can %i[show update destroy], User, id: user.id
  
      return unless user.role == 'admin'
      can :manage, :all
    end
end
