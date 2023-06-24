# frozen_string_literal: true

class CreateApps < ActiveRecord::Migration[7.0] # rubocop:todo Style/Documentation
  def change
    create_table :apps do |t|
      t.string :name, null: false
      t.integer :dg_app_id, null: false

      t.timestamps
    end
  end
end
