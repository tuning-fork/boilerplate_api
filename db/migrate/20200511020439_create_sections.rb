# frozen_string_literal: true

class CreateSections < ActiveRecord::Migration[6.0]
  def change
    create_table :sections do |t|
      t.integer :grant_id
      t.string :title
      t.text :text
      t.integer :sort_order
      t.integer :boilerplate_id

      t.timestamps
    end
  end
end
