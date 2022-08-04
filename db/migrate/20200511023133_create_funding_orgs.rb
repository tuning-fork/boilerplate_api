# frozen_string_literal: true

class CreateFundingOrgs < ActiveRecord::Migration[6.0]
  def change
    create_table :funding_orgs do |t|
      t.string :website
      t.string :name
      t.integer :org_id

      t.timestamps
    end
  end
end
