class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :create, Course if user.invitation_accepted? or user.collaborator?
    can :update, Course do |course|
      course.user_id == user.id or course.group.collaborator?(user)
    end
    can :update, Group, user_id: user.id
    can :manage, :all if user.admin?
  end
end
