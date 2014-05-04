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
    user.present? && (user.role == "admin" || user.id == wiki.user_id)
  end

  def destroy?
    update?
  end

  def show?
    if wiki.private?
      auth_private?
    else
      auth_public?
    end
  end


  private

  def auth_private?
     user.present? && (user.role == "admin" || user.id == wiki.user_id)
  end

  def auth_public?
    true if !wiki.private?
  end

end
