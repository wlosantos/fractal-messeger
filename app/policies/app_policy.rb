# frozen_string_literal: true

class AppPolicy < ApplicationPolicy
  def index?
    permissions?
  end

  def show?
    permissions?
  end

  def create?
    permissions?
  end

  def update?
    permissions?
  end

  def destroy?
    permissions?
  end
end
