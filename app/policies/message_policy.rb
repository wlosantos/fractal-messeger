# frozen_string_literal: true

# Permission for message
class MessagePolicy < ApplicationPolicy
  def create?
    permissions? || user == record.user
  end

  def update?
    permissions? || user == record.user
  end

  def destroy?
    permissions? || user == record.user
  end
end
