class CreateGrants < ActiveRecord::Migration[6.0]
  def change
    create_table :grants do |t|
      t.integer :org_id
      t.string :title
      t.integer :funding_org_id
      t.string :rfp_url
      t.datetime :deadline
      t.boolean :submitted
      t.boolean :successful

      t.timestamps
    end
  end
end
