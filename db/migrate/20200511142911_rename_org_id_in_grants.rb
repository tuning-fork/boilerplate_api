# frozen_string_literal: true

class RenameOrgIdInGrants < ActiveRecord::Migration[6.0]
  def change
    rename_column :grants, :org_id, :organization_id
  end
end
