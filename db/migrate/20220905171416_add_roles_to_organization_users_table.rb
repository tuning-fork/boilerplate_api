# frozen_string_literal: true

class AddRolesToOrganizationUsersTable < ActiveRecord::Migration[6.0]
  def change
    change_table :organization_users, bulk: true do |t|
      t.string :roles, array: true, default: []
    end
  end
end
