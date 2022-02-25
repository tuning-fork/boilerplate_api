class DropBioGrant < ActiveRecord::Migration[6.0]
  def change
    drop_table :bio_grants
  end
end
