# frozen_string_literal: true

class CreateBoilerplates < ActiveRecord::Migration[6.0]
  def change
    create_table :boilerplates do |t|
      t.integer :org_id
      t.integer :category_id
      t.string :title
      t.text :text
      t.integer :wordcount

      t.timestamps
    end
  end
end
