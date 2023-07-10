# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    permissions? || user == record.create_by
  end

  def update?
    permissions? || user == record.create_by
  end

  def destroy?
    permissions? || user == record.create_by
  end
end
