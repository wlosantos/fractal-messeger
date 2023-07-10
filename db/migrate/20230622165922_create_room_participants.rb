# frozen_string_literal: true

class CreateRoomParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :room_participants do |t|
      t.boolean :is_blocked, null: false, default: false
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
