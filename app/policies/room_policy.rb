# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  def index?
    permissions? || user == record.create_by
  end

  def show?
    permissions? || user == record.create_by
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
