# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  def index?
    permissions? || user == record.origin
  end

  def show?
    permissions? || user == record.origin
  end

  def create?
    permissions? || user == record.origin
  end

  def update?
    permissions? || user == record.origin
  end

  def destroy?
    permissions? || user == record.origin
  end
end
