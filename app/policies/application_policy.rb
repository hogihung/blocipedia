class ApplicationPolicy
  attr_reader :user, :wiki

  def initialize(user, wiki)
    # Leaving for now as I may need to use, but in a different context.
    # With this on, non-registered users are not allowed to use Show action.
    #raise Pundit::NotAuthorizedError, "Must be logged in." unless user
    @user = user
    @wiki = wiki
  end

  def index?
    false
  end

  def show?
    scope.where(:id => wiki.id).exists?
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user.present? && (wiki.user == user || user.role == "admin")
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def scope
    wiki.class
  end
end

