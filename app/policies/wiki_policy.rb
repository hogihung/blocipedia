class WikiPolicy < ApplicationPolicy

  def index?
    true
  end

  def can_create_private_wiki?
    user.present? && user.role == "premium"
  end

  def create?
    user.present?
  end

  def update?
    create?
  end

  def destroy?
    user.present? && (user.role == "admin" || user.id == wiki.user_id)
  end

  def show?
    !wiki.private? || (wiki.private? && user.id == wiki.user_id if user.present?)
  end

end
