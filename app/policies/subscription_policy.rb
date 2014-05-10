class SubscriptionPolicy < ApplicationPolicy

  def create?
    user.present? && user.role == "member"
  end

end