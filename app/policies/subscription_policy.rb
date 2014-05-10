class SubscriptionPolicy < ApplicationPolicy

  def create?
    user.present? && user.role == "member"
  end

  def destroy?
    user.present? && user.role == "premium"
  end

end