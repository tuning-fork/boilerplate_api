class DropReviewers < ActiveRecord::Migration[6.0]
    def change
      drop_table :reviewers
    end
end
