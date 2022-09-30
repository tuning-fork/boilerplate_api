# frozen_string_literal: true

class CreateOrganizationInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :invitations, id: :uuid do |t|
      t.string :email, null: false
      t.string :token
      t.date :expires_at
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.references :user, null: true, foreign_key: true, type: :uuid
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.index %i[email organization_id], unique: true

      t.timestamps
    end
  end
end
