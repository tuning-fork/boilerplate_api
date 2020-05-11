class RenameOrgIdInCategories < ActiveRecord::Migration[6.0]
  def change
    rename_column :categories, :org_id, :organization_id
  end
end
