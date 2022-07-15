# frozen_string_literal: true

class AddUniqueIndexToOrganizationUser < ActiveRecord::Migration[6.0]
  def change
    add_index :organization_users, %i[organization_id user_id], unique: true
  end
end
