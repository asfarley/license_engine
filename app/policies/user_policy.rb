class UserPolicy
  attr_reader :user_subject, :user_object

  def initialize(user_subject, user_object)
    @user_subject = user_subject
    @user_object = user_object
  end

  def index?
    @user_subject.has_role? :admin
  end

  def emails?
    @user_subject.has_role? :admin
  end

  def new?
    @user_subject.has_role? :admin
  end

  def update?
    @user_subject.has_role? :admin
  end

  def destroy?
    @user_subject.has_role? :admin
  end

  def activity?
    @user_subject.has_role? :admin
  end

  def set_admin?
    @user_subject.has_role? :admin
  end

  def unset_admin?
    @user_subject.has_role? :admin
  end

  def edit?
    @user_subject.has_role? :admin
  end

end