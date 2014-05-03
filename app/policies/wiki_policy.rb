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
    update?
  end

  def show?
    # changes here ....
    !wiki.private? || user.id == wiki.user_id
  end

end
