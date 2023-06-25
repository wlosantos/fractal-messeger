# frozen_string_literal: true

class ApplicationPolicy # rubocop:todo Style/Documentation
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def permissions?
    user.has_role?(:admin) || user.has_role?(:manager)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope # rubocop:todo Style/Documentation
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
