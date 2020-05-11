class RenameOrgIdInBios < ActiveRecord::Migration[6.0]
  def change
    rename_column :bios, :org_id, :organization_id
  end
end
