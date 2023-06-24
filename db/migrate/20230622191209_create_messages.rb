# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :content, null: false, default: ''
      t.integer :status_moderation, null: false, default: 0
      t.timestamp :moderated_at, null: true
      t.timestamp :refused_at, null: true
      t.references :moderator, null: true, foreign_key: { to_table: :users }
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :messages }

      t.timestamps
    end
  end
end
