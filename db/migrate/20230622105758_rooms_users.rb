# frozen_string_literal: true

class RoomsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms_users, id: false do |t|
      t.belongs_to :room, index: true
      t.belongs_to :user, index: true
    end
  end
end
