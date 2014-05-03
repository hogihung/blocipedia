class WikiPolicy < ApplicationPolicy

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
    record.public? || user.present?
  end

end
