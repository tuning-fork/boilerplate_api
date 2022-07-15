# frozen_string_literal: true

class CreateBios < ActiveRecord::Migration[6.0]
  def change
    create_table :bios do |t|
      t.integer :org_id
      t.string :first_name
      t.string :last_name
      t.text :text

      t.timestamps
    end
  end
end
