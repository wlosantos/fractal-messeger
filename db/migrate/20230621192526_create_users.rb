# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0] # rubocop:todo Style/Documentation
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :fractal_id, null: false, index: { unique: true }
      t.string :dg_token, null: false

      t.timestamps
    end
  end
end
