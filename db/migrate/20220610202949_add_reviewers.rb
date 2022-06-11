class AddReviewers < ActiveRecord::Migration[6.0]
  def change
    create_table :reviewers do |t|
      t.integer :user_id
      t.integer :grant_id

      t.timestamps
    end
  end
end
