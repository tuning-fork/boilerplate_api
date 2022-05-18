class CreateReviewers < ActiveRecord::Migration[6.0]
  def change
    create_table :reviewers, id: :uuid do |t|
      t.references :grants, null: false, foreign_key: true
      t.references :users, null: false, foreign_key: true

      t.timestamps
    end
  end
end
