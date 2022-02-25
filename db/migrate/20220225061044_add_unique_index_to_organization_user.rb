class AddUniqueIndexToOrganizationUser < ActiveRecord::Migration[6.0]
  def change
    add_index :organization_users, [:organization_id, :user_id], unique: true
  end
end
