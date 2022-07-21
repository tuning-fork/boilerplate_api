# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.integer :grant_id
      t.string :title
      t.datetime :deadline
      t.boolean :submitted

      t.timestamps
    end
  end
end
