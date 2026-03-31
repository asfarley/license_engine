class LicensePolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.has_role? :admin
        scope.all
      else
        scope.where(company: user.company)
      end
    end
    private
    attr_reader :user, :scope
  end

  attr_reader :user, :license

  def initialize(user, license)
    @user = user
    @license = license
  end

  def index?
    @user.has_role? :admin
  end

  def new?
    @user.has_role? :admin
  end

  def show?
    @user.has_role? :admin
  end

  def edit?
    @user.has_role? :admin
  end

  def create?
    @user.has_role? :admin
  end

  def update?
    @user.has_role? :admin
  end

  def destroy?
    @user.has_role? :admin
  end

end