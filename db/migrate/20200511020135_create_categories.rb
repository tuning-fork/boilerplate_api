# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.integer :org_id
      t.string :name

      t.timestamps
    end
  end
end
