# frozen_string_literal: true

class CreateBioGrants < ActiveRecord::Migration[6.0]
  def change
    create_table :bio_grants do |t|
      t.integer :grant_id
      t.integer :bio_id

      t.timestamps
    end
  end
end
