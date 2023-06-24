# frozen_string_literal: true

class AddAppIdToUsers < ActiveRecord::Migration[7.0] # rubocop:todo Style/Documentation
  def change
    add_reference :users, :app, null: false, foreign_key: true
  end
end
